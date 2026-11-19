testing
isQuiet

	"Whether the VM is idle rather than half way through changing its heap: no thread
	running, and the main thread blocked in a system call (its syscall file starts
	with the call's number; -1 is stopped in user code, running a thread that runs or is gone)."

	| main |
	(self threadRegisters allSatisfy: [ :each | each includesKey: #rip ]) ifFalse: [ ^ false ].
	main := (self class syscallFieldsIn: (self pathFor: 'task/' , self mainThreadId) asFileReference) first.
	^ main ~= '-1' and: [ main ~= 'running' ]
