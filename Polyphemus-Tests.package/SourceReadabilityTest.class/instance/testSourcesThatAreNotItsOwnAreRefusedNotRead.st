tests
testSourcesThatAreNotItsOwnAreRefusedNotRead

	"A .sources file not named after the image is still picked up, as a fallback. Its text at
	this image's source pointers is not this image's methods: refuse it rather than show it."

	| memory stack |
	(directory / 'other.sources') writeStreamDo: [ :out |
		1 to: 20000 do: [ :each | out nextPutAll: 'not the source of anything '; cr ] ].
	memory := Polyphemus readImageFile: self pinnedImageAlone.

	self deny: (memory sourceReadability canRead: #source).
	self
		assert: (memory sourceReadability whyNot: #source)
		equals: #itsMethodsDoNotReadAsTheirSource.
	stack := memory activationsOfProcess: memory allReifiedProcesses first.
	self assert: (memory sourceOfContext: stack first) isNil
