reading registers
registersOfThread: anId

	"Its x64 CONTEXT (control and integer registers), named as a minidump's are: suspended a
	moment unless it is ours that asks. 16-byte aligned, so allocated outside the heap. nil
	when the thread is gone."

	| thread context registers ours |
	thread := self class openThread: 16r004A inherit: 0 id: anId.
	thread = 0 ifTrue: [ ^ nil ].
	ours := anId = self class currentThreadId.
	context := ExternalAddress allocate: 1232.
	[
	1 to: 1232 do: [ :index | context byteAt: index put: 0 ].
	context unsignedLongAt: 16r30 + 1 put: 16r100003.
	ours ifFalse: [ self class suspendThread: thread ].
	[ (self class context: thread into: context) = 0 ifTrue: [ ^ nil ] ] ensure: [
		ours ifFalse: [ self class resumeThread: thread ] ].
	registers := Dictionary new.
	#( #rax #rcx #rdx #rbx #rsp #rbp #rsi #rdi #r8 #r9 #r10 #r11 #r12 #r13 #r14 #r15 #rip ) doWithIndex: [ :each :index |
		registers at: each put: (context unsignedLongLongAt: 16r78 + (index - 1 * 8) + 1) ].
	registers at: #eflags put: (context unsignedLongAt: 16r44 + 1) ] ensure: [
		context free.
		self class closeHandle: thread ].
	^ registers
