context protocol
tempAt: anIndex

	"The nth argument or temporary, counted as a context counts, arguments first; read through
	the VM's frame layout and bounded by the temporary count. Refused by name where its code or
	the word does not read."

	| code word |
	code := self compiledCode ifNil: [ ^ self signalMachineCode ].
	(anIndex between: 1 and: code numTemps) ifFalse: [
		^ NotInTheReading signal: 'this frame has no temporary ' , anIndex printString ].
	word := self layout temporary: anIndex - 1 in: framePointer.
	^ (self layout objectAt: word) ifNil: [
		  self refuseItsField: 'temporary ' , anIndex printString holding: word ]
