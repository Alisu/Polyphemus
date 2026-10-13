reading
read: aCount at: anAddress

	"aCount bytes straight from the task, or nil unless all of them were read."

	| bytes read |
	bytes := self class pinned: aCount.
	read := self class pinned: 8.
	(self class read: task at: anAddress count: aCount into: bytes size: read) = 0 ifFalse: [ ^ nil ].
	^ (read unsignedLongLongAt: 1) = aCount
		  ifTrue: [ bytes ]
		  ifFalse: [ nil ]
