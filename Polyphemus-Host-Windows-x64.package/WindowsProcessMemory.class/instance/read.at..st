reading
read: aCount at: anAddress

	"aCount bytes straight from the process, or nil unless all of them were read."

	| bytes done |
	bytes := self class pinned: aCount.
	done := self class pinned: 8.
	(self class read: handle at: anAddress into: bytes count: aCount done: done) = 0 ifTrue: [ ^ nil ].
	^ (done unsignedLongLongAt: 1) = aCount
		  ifTrue: [ bytes ]
		  ifFalse: [ nil ]
