checking
checkBeforeResuming: aProcessMemory

	"Checked only when its heap was written, not the VM's own variables, and not while its VM
	collects: the VM then has its free lists and its heap disagreeing itself; counted (#173).
	A problem says what the VM was doing when stopped (#165)."

	| addresses heap found |
	addresses := written removeKey: aProcessMemory ifAbsent: [ ^ self ].
	heap := SpurRawHeap on: aProcessMemory.
	(self wasWritten: heap at: addresses) ifFalse: [ ^ self ].
	aProcessMemory whyCollecting ifNotNil: [ :why | ^ unchecked add: why ].
	found := self class problemsOf: heap.
	found ifEmpty: [ ^ self ].
	problems addAll: (found collect: [ :each | each , ' (its VM stopped ' , aProcessMemory howItWasStopped , ')' ])
