writing
write: aByteArray at: anAddress

	"Through the process handle (WriteProcessMemory), the blocks read before forgotten."

	| bytes done |
	bytes := self class pinned: aByteArray size.
	bytes replaceFrom: 1 to: aByteArray size with: aByteArray startingAt: 1.
	done := self class pinned: 8.
	blocks := nil.
	(self class write: self handle at: anAddress from: bytes count: aByteArray size done: done) = 0 ifTrue: [
		^ self error: 'WriteProcessMemory refused' ]
