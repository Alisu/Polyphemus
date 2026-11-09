reading
machineCodeTextOf: aMethodAddress

	"The CogMethod Cog compiled of the method at that address, read only: header, map from
	machine code pcs to bytecode pcs, bytes (#95). nil when its header holds no CogMethod."

	| header cogMethod start |
	header := self wordAt: aMethodAddress + memory wordSize.
	((header bitAnd: 1) = 0 and: [ raw isMachineCodeAddress: header ]) ifFalse: [ ^ nil ].
	cogMethod := self cogit cogMethodSurrogateAt: header.
	start := memory interpreter startPCOfMethodHeader: cogMethod methodHeader.
	^ String streamContents: [ :s |
		  s nextPutAll: 'CogMethod at 16r' , header printStringHex , ', ' , cogMethod blockSize printString , ' bytes'; cr.
		  s nextPutAll: 'arguments ' , cogMethod cmNumArgs printString , ', ' , (self nameOfMethodType: cogMethod cmType)
			  , ', refers to young ' , (cogMethod cmRefersToYoung = 1) printString , ', stack check at +16r'
			  , cogMethod stackCheckOffset printStringHex; cr; cr.
		  s nextPutAll: 'Map: machine code pc, what Cog noted there'; cr.
		  self cogit mapFor: cogMethod do: [ :annotation :mcpc |
			  s nextPutAll: '  16r' , mcpc printStringHex , '  ' , (self nameOfAnnotation: annotation).
			  (self cogit isPCMappedAnnotation: annotation) ifTrue: [
				  ([ self cogit bytecodePCFor: mcpc startBcpc: start in: cogMethod ] on: Error do: [ :e | 0 ])
					  ifNotNil: [ :bcpc | bcpc > 0 ifTrue: [ s nextPutAll: '  -> bytecode pc ' , (bcpc + 1) printString ] ] ].
			  annotation >= (Cogit bindingOf: #IsSendCall) value ifTrue: [
				  (self linkOfSendAt: mcpc) ifNotNil: [ :link | s nextPutAll: ', ' , link ] ].
			  s cr.
			  false ].
		  s cr; nextPutAll: 'Bytes'; cr.
		  0 to: cogMethod blockSize - 1 by: 16 do: [ :offset |
			  s nextPutAll: '  16r' , (header + offset) printStringHex , ' '.
			  offset to: (offset + 15 min: cogMethod blockSize - 1) do: [ :i |
				  s space; nextPutAll: ((self byteAt: header + i) printStringBase: 16 nDigits: 2) ].
			  s cr ] ]
