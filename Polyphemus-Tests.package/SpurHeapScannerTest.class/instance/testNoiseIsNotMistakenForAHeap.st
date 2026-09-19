tests
testNoiseIsNotMistakenForAHeap

	"Noise stops within a few objects, so the length of a walk means something."

	| noise space scanner |
	noise := ByteArray new: 65536.
	1 to: noise size do: [ :index |
		noise at: index put: (index * 7919 + 13) \\ 256 ].
	space := ByteArrayAddressSpace on: noise at: self baseAddress.
	scanner := SpurHeapScanner on: space.

	self assert: (scanner walkFrom: self baseAddress upTo: self baseAddress + noise size)
			 objectCount < 5.
	self deny: (scanner
			 looksLikeAHeapFrom: self baseAddress
			 upTo: self baseAddress + noise size)
