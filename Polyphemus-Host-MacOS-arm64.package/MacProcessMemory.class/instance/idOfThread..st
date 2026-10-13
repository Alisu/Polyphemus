reading registers
idOfThread: aThreadPort

	"The system-wide thread id (THREAD_IDENTIFIER_INFO, flavor 4: thread_id at 0); nil when gone."

	| info count |
	info := self class pinned: 24.
	count := self class pinned: 4.
	count unsignedLongAt: 1 put: 6.
	(self class thread: aThreadPort info: 4 into: info count: count) = 0 ifFalse: [ ^ nil ].
	^ info unsignedLongLongAt: 1
