tests
testItDoesNotTakeALoneHeaderForAHeap

	"A single header that looks like nil is worth nothing: this is the mistake that cost a
	real search. Without the two objects after it, and without a walk that runs, a table of
	numbers passes for a heap."

	| specs space |
	specs := OrderedCollection new.
	specs add: #( 3075 0 0 ).
	specs add: #( 4867 0 0 ).
	600 timesRepeat: [ specs add: #( 8195 0 0 ) ].
	space := self spaceFor: specs.

	self assert: ((SpurHeapScanner on: space)
			 heapStartFrom: self baseAddress
			 upTo: self baseAddress + space size) isNil
