reading registers
registersOfThread: anId

	"Its x64 CONTEXT (control and integer registers), named as a minidump's are: suspended a
	moment unless it is ours that asks. 16-byte aligned, so allocated outside the heap. nil
	when the thread is gone."

	| thread context ours |
	thread := self class openThread: self class toSuspendAndReadAThread inherit: 0 id: anId.
	thread = 0 ifTrue: [ ^ nil ].
	ours := anId = self class currentThreadId.
	context := ExternalAddress allocate: WindowsX64Context byteSize.
	^ [
	  1 to: WindowsX64Context byteSize do: [ :index | context byteAt: index put: 0 ].
	  WindowsX64Context askForRegistersIn: context.
	  ours ifFalse: [ self class suspendThread: thread ].
	  [ (self class context: thread into: context) = 0 ifTrue: [ ^ nil ] ] ensure: [
		  ours ifFalse: [ self class resumeThread: thread ] ].
	  WindowsX64Context registersIn: context ] ensure: [
		  context free.
		  self class closeHandle: thread ]
