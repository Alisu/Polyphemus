initialization
setThread: aThreadPort in: aMacProcessMemory files: someMappedFiles codeZone: anAssociationOrNil

	"Its run state (thread_info), sp and pc (thread_get_state); waiting in the kernel, its pc
	is just after svc #0x80 in a libsystem_kernel stub, which names the call (#36)."

	| info registers |
	id := aMacProcessMemory idOfThread: aThreadPort.
	info := aMacProcessMemory basicInfoOfThread: aThreadPort.
	state := info
		         ifNil: [ '?' ]
		         ifNotNil: [ #( 'running' 'stopped' 'waiting' 'uninterruptible' 'halted' ) at: (info signedLongAt: 25) ifAbsent: [ '?' ] ].
	wasRunning := state = 'running'.
	registers := (aMacProcessMemory registersOfThread: aThreadPort) ifNil: [ ^ self ].
	sp := registers at: #sp.
	pc := registers at: #pc.
	location := self class locationOf: pc codeZone: anAssociationOrNil files: someMappedFiles.
	(aMacProcessMemory isInASystemCallAt: pc) ifTrue: [
		number := registers at: #x16.
		callName := (self class symbolAt: pc) ifNotNil: [ :symbol | symbol value ] ]
