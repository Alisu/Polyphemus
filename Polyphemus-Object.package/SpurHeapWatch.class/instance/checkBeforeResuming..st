checking
checkBeforeResuming: aProcessMemory

	"Checked only when its heap was written, not the VM's own variables, and not while its VM
	collects or is in its own code: it then has its free lists and its heap disagreeing itself;
	counted (#173, #165). A problem says what the VM was doing when stopped."

	| addresses heap found |
	addresses := written removeKey: aProcessMemory ifAbsent: [ ^ self ].
	heap := SpurRawHeap on: aProcessMemory.
	(self wasWritten: heap at: addresses) ifFalse: [ ^ self ].
	aProcessMemory whyCollecting ifNotNil: [ :why | ^ unchecked add: why ].
	aProcessMemory wasStoppedInItsOwnCode ifTrue: [
		^ unchecked add: 'in its own code, not at rest: an allocation of its own may be half done' ].
	found := self class problemsOf: heap.
	found ifEmpty: [ ^ self ].
	problems addAll: (found collect: [ :each | each , ' (its VM stopped ' , aProcessMemory howItWasStopped , ')' ])
