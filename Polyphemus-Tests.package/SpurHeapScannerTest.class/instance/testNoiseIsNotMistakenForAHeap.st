tests
testNoiseIsNotMistakenForAHeap

	"The whole method rests on this. If bytes that are not a heap walked as far as a heap
	does, the length of a run would say nothing at all.

	This pattern stops at once, on the first header, because its class index is far larger
	than any image has classes -- that one check is what does most of the work. Measured
	outside this image on real noise: three thousand walks from random places in two megabytes
	never got past two objects with that check, and up to seventy-eight without it.

	Sixty four kilobytes, so that a heap of objects this size would be thousands of them and
	the threshold is a real one to fall short of."

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
