tests
testZeroedMemoryIsSteppedOverAndSaid

	"#211: a header of zero has the class index of free space. No free chunk of a sound heap has
	one (none among 925,184 stepped in a real core): the walk goes on past it, so that what follows
	is still read, and says where it first met it. A sound heap has none to say."

	| specs space walk |
	specs := self aFewObjects , #( #( 18 2 1 ) #( 0 0 0 ) #( 0 0 0 ) #( 18 2 1 ) ).
	space := self spaceFor: specs.
	walk := (SpurHeapScanner on: space) walkFrom: self baseAddress upTo: self baseAddress + space size.

	self assert: walk reachedTheLimit.
	self assert: walk objectCount equals: self aFewObjects size + 2.
	self assert: walk firstZeroedHeader equals: ((self addressesOf: specs) at: self aFewObjects size + 2) key.
	space := self spaceFor: self aFewObjects.
	walk := (SpurHeapScanner on: space) walkFrom: self baseAddress upTo: self baseAddress + space size.
	self assert: walk firstZeroedHeader isNil
