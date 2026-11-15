damages
damagesOfGlobalsIn: aCleanReading

	"In the array of the globals (#118): the entry of ZnConstants a tagged word, and the key of the
	binding of ZnEasy a tagged word. Two names no test here asks a class of."

	| globals entryOf |
	globals := (aCleanReading reifiedSmalltalk reifiedSlotAt: 1) reifiedSlotAt: 2.
	entryOf := [ :name |
	           | binding |
	           binding := (aCleanReading globalNamed: name) ifNil: [ self error: 'no global ' , name ].
	           (1 to: globals oopNumberOfSlots) detect: [ :index | (globals reifiedSlotAt: index) = binding ] ].
	^ {
		  ((DamagedCandleImage slot: (entryOf value: #ZnConstants) of: globals) -> self taggedWord).
		  ((DamagedCandleImage slot: 1 of: (aCleanReading globalNamed: #ZnEasy)) -> self taggedWord) }
