writing
write: aByteArray at: anAddress

	"Through the process handle (WriteProcessMemory)."

	| bytes done |
	bytes := self class pinned: aByteArray size.
	bytes replaceFrom: 1 to: aByteArray size with: aByteArray startingAt: 1.
	done := self class pinned: 8.
	(self class write: self handle at: anAddress from: bytes count: aByteArray size done: done) = 0 ifTrue: [
		^ self error: 'WriteProcessMemory refused' ]
