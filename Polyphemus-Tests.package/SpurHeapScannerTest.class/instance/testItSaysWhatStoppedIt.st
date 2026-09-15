tests
testItSaysWhatStoppedIt

	"A walk that stops is more useful when it says why. A class index far larger than any image
	has classes is the commonest thing to land on when a walk leaves the objects, and it is not
	the same failure as a header claiming an object longer than the region holding it."

	| bytes space walk |
	bytes := self heapBytesFor: { #( 17 1 1 ). #( 18 1 1 ) }.
	"the second object's header begins at byte 17; give it an impossible class"
	bytes
		at: 17 put: 16rFF;
		at: 18 put: 16rFF;
		at: 19 put: 16r3F.

	space := ByteArrayAddressSpace on: bytes at: self baseAddress.
	walk := (SpurHeapScanner on: space)
		        walkFrom: self baseAddress
		        upTo: self baseAddress + bytes size.

	self assert: walk objectCount equals: 1.
	self assert: walk reason equals: #classIndexTooLarge.
	self deny: walk reachedTheLimit
