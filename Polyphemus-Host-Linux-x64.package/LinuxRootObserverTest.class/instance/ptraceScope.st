helpers
ptraceScope

	^ [ '/proc/sys/kernel/yama/ptrace_scope' asFileReference contents trimBoth asNumber ]
		  on: Error
		  do: [ :e | 0 ]
