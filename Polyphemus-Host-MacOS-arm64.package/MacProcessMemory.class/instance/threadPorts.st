reading registers
threadPorts

	"Each thread's port (task_threads), the main thread first."

	| list count ports threads |
	list := self class pinned: 8.
	count := self class pinned: 4.
	(self class taskThreads: task list: list count: count) = 0 ifFalse: [ ^ #(  ) ].
	ports := ExternalAddress fromAddress: (list unsignedLongLongAt: 1).
	threads := (1 to: (count unsignedLongAt: 1)) collect: [ :i | ports unsignedLongAt: i - 1 * 4 + 1 ].
	self class deallocate: self class selfTask at: (list unsignedLongLongAt: 1) size: (count unsignedLongAt: 1) * 4.
	^ threads asArray
