naming
methodTrailerClass

	"How the image read writes its methods' trailers: five fixed bytes from Pharo 12 on -- its
	CompiledMethod answers trailerSize -- and Pharo's variable ones before, Candle's too. Where
	its CompiledMethod does not tell its methods, told from the methods' own last bytes (#118)."

	^ self rememberedAt: 'methodTrailerClass' ifAbsentPut: [
		  | hasFixed |
		  hasFixed := [ ((self oopClassNamed: 'CompiledMethod') oopClass methodNamed: 'trailerSize' ifAbsent: [ nil ]) notNil ]
			              on: PolyphemusError
			              do: [ :refusal | nil ].
		  hasFixed
			  ifNil: [ self methodTrailerClassByShape ]
			  ifNotNil: [ hasFixed ifTrue: [ OOPFixedMethodTrailer ] ifFalse: [ OOPVariableMethodTrailer ] ] ]
