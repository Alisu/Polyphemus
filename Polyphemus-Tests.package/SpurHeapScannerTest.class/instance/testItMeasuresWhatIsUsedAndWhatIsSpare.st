tests
testItMeasuresWhatIsUsedAndWhatIsSpare

	"How much of its memory was the image using? The walk knows: every object it steps over has
	a size, and free chunks are measured apart from live objects. Against the size of the
	mapping that says what was in use and what the allocator was merely holding."

	| specs space walk |
	specs := OrderedCollection new.
	specs add: #( 3075 0 0 ); add: #( 3077 0 0 ); add: #( 3079 0 0 ).
	600 timesRepeat: [ specs add: #( 17 1 2 ) ].
	specs add: #( 0 0 10 ).
	space := self spaceFor: specs.

	walk := (SpurHeapScanner on: space)
		        walkFrom: self baseAddress
		        upTo: self baseAddress + space size.

	self assert: walk objectCount equals: 603.
	self assert: walk freeChunkCount equals: 1.
	self assert: walk liveBytes equals: 3 * 16 + (600 * 24).
	self assert: walk freeBytes equals: 8 + (10 * 8).
	self assert: walk liveBytes + walk freeBytes equals: space size
