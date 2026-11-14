context protocol
tempAt: anIndex

	"The nth argument or temporary, counted as a context counts, arguments first; read
	through the VM's frame layout and bounded by the temporary count."

	| count word |
	count := [ self compiledCode numTemps ] on: Error do: [ :e | 0 ].
	(anIndex between: 1 and: count) ifFalse: [
		^ NotInTheReading signal: 'this frame has no temporary ' , anIndex printString ].
	word := self layout temporary: anIndex - 1 in: framePointer.
	^ (self layout objectAt: word) ifNil: [
		  self refuseItsField: 'temporary ' , anIndex printString holding: word ]
