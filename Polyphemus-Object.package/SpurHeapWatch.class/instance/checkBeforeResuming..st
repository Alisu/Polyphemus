checking
checkBeforeResuming: aProcessMemory

	"Checked only when its heap was written, not the VM's own variables, and not while its VM
	collects: the VM then has its free lists and its heap disagreeing itself; counted (#173)."

	| addresses heap |
	addresses := written removeKey: aProcessMemory ifAbsent: [ ^ self ].
	heap := SpurRawHeap on: aProcessMemory.
	(self wasWritten: heap at: addresses) ifFalse: [ ^ self ].
	aProcessMemory whyCollecting ifNotNil: [ :why | ^ unchecked add: why ].
	problems addAll: (self class problemsOf: heap)
