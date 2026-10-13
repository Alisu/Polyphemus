reading registers
threadRegisters

	"Each thread's arm64 registers (task_threads, thread_get_state): #x0 to #x28, #fp, #lr,
	#sp, #pc and #pstate, as ElfCoreDump answers them from an aarch64 core."

	| list count ports threads |
	list := self class pinned: 8.
	count := self class pinned: 4.
	(self class taskThreads: task list: list count: count) = 0 ifFalse: [ ^ #(  ) ].
	ports := ExternalAddress fromAddress: (list unsignedLongLongAt: 1).
	threads := (1 to: (count unsignedLongAt: 1)) collect: [ :i |
		           self registersOfThread: (ports unsignedLongAt: i - 1 * 4 + 1) ].
	self class deallocate: self class selfTask at: (list unsignedLongLongAt: 1) size: (count unsignedLongAt: 1) * 4.
	^ (threads reject: [ :each | each isNil ]) asArray
