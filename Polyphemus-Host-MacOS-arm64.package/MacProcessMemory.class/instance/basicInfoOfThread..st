reading registers
basicInfoOfThread: aThreadPort

	"THREAD_BASIC_INFO (flavor 3, 10 words): run_state at 24 (1 running, 2 stopped, 3 waiting,
	4 uninterruptible, 5 halted), suspend_count at 32. nil when the thread is gone."

	| info count |
	info := self class pinned: 40.
	count := self class pinned: 4.
	count unsignedLongAt: 1 put: 10.
	(self class thread: aThreadPort info: 3 into: info count: count) = 0 ifFalse: [ ^ nil ].
	^ info
