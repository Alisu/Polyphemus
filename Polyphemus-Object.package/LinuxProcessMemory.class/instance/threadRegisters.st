accessing
threadRegisters

	"Where each thread was, from /proc/<pid>/task/<tid>/syscall: a blocked thread gives its
	stack pointer and pc last (after -1 when not in a system call), a running one only
	`running`, which gives no registers."

	^ (self pathFor: 'task') asFileReference directories collect: [ :task |
		  | fields registers |
		  registers := Dictionary new.
		  fields := ([ (task / 'syscall') contents trimBoth ] on: Error do: [ :e | 'running' ])
			            substrings: ' '.
		  fields size >= 3 ifTrue: [
			  registers
				  at: #rsp put: (self hexValueOf: (fields at: fields size - 1));
				  at: #rip put: (self hexValueOf: fields last) ].
		  registers ]
