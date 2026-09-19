tests
testItFindsWhereAHeapBegins

	"The heap is found by the nil, false, true triple, not by one nil-like header."

	| specs space start |
	specs := OrderedCollection new.
	specs add: #( 3075 0 0 ); add: #( 3077 0 0 ); add: #( 3079 0 0 ).
	600 timesRepeat: [ specs add: #( 17 1 2 ) ].
	space := self spaceFor: specs.

	start := (SpurHeapScanner on: space)
		         heapStartFrom: self baseAddress
		         upTo: self baseAddress + space size.

	self assert: start equals: self baseAddress
