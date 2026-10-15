writing
storeBytes: aByteArray at: anAddress

	"Write them through the process handle (WriteProcessMemory), and forget the blocks read
	before. Refused while the process runs, as on Linux and macOS (#24)."

	| bytes done |
	self isStopped ifFalse: [ ^ self error: 'refusing to write to a process that is running' ].
	(self hasAddress: anAddress) ifFalse: [ ^ self error: 'nothing is mapped at ' , anAddress printStringHex ].
	bytes := self class pinned: aByteArray size.
	bytes replaceFrom: 1 to: aByteArray size with: aByteArray startingAt: 1.
	done := self class pinned: 8.
	blocks := nil.
	(self class write: handle at: anAddress from: bytes count: aByteArray size done: done) = 0 ifTrue: [
		^ self error: 'WriteProcessMemory refused' ].
	^ aByteArray size
