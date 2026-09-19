context protocol
tempAt: anIndex

	"The nth argument or temporary, counted as a context counts, arguments first; read
	through the VM's frame layout and bounded by the temporary count."

	| count |
	count := [ self compiledCode numTemps ] on: Error do: [ :e | 0 ].
	(anIndex between: 1 and: count) ifFalse: [
		^ self error: 'this frame has no temporary ' , anIndex printString ].

	^ memory objectAt:
		  (memory interpreter temporary: anIndex - 1 in: framePointer)
