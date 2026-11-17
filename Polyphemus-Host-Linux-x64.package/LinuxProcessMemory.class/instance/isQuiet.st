testing
isQuiet

	"Whether the VM is idle rather than half way through changing its heap: no thread
	running, and the main thread blocked in a system call (/proc/<pid>/task/<pid>/syscall
	starts with the call's number; -1 is stopped in user code)."

	| main |
	(self threadRegisters allSatisfy: [ :each | each includesKey: #rip ]) ifFalse: [ ^ false ].
	main := [ ((self pathFor: 'task/' , self mainThreadId , '/syscall') asFileReference contents substrings: ' ') first ]
		        on: Error
		        do: [ :e | '-1' ].
	^ main ~= '-1' and: [ main ~= 'running' ]
