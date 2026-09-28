tests
testItFindsAHeapWhoseFirstClassesAreElsewhereInTheTable

	"#61: Pharo 14 gives nil, false and true the class indexes 2051, 2053 and 2055, not
	Pharo 10's 3075, 3077 and 3079. The shape is the heap's, not the numbers."

	| specs space start |
	specs := OrderedCollection new.
	specs add: #( 2051 0 0 ); add: #( 2053 0 0 ); add: #( 2055 0 0 ).
	600 timesRepeat: [ specs add: #( 17 1 2 ) ].
	space := self spaceFor: specs.

	start := (SpurHeapScanner on: space)
		         heapStartFrom: self baseAddress
		         upTo: self baseAddress + space size.

	self assert: start equals: self baseAddress
