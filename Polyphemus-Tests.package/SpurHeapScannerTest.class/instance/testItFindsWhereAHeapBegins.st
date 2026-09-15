tests
testItFindsWhereAHeapBegins

	"Nothing in a dump says where the heap is. It is found by its first three objects -- nil,
	false and true, of no slots, sixteen bytes apart -- and then confirmed by walking from
	them.

	One header is not enough to go on. A table of small numbers in a real dump read as three
	hundred and fifty eight objects in a row before the walk wandered into text; the triple,
	searched over two hundred megabytes, matched in exactly one place, and the walk from there
	ran for a million objects."

	| specs space start |
	specs := OrderedCollection new.
	specs add: #( 3075 0 0 ); add: #( 3077 0 0 ); add: #( 3079 0 0 ).
	600 timesRepeat: [ specs add: #( 17 1 2 ) ].
	space := self spaceFor: specs.

	start := (SpurHeapScanner on: space)
		         heapStartFrom: self baseAddress
		         upTo: self baseAddress + space size.

	self assert: start equals: self baseAddress
