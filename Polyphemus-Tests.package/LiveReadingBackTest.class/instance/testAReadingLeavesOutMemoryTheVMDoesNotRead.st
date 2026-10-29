tests
testAReadingLeavesOutMemoryTheVMDoesNotRead

	"A reading copies what it reads of the process, heap, machine code, stacks and the VM's own
	variables, not everything the process could write: on macOS that was malloc's zones too (#122)."

	| script pid |
	script := self spinningTargetScript
		          copyReplaceAll: 'Smalltalk garbageCollect.'
		          with: '(dir / ''outside'') writeStreamDo: [ :stream |
	| outside |
	outside := ExternalAddress allocate: 33554432.
	1 to: 33554432 by: 4096 do: [ :i | outside byteAt: i put: 1 ].
	stream print: outside asInteger ].
Smalltalk garbageCollect.'.
	pid := self launchTargetRunning: script.
	self withAnAgentIn: pid do: [ :channel :reader |
		| held |
		held := HeldProcess on: channel reader: reader identityHash: (self runawayHashIn: reader).
		held topContext.
		self deny: (held dumped raw space hasAddress: (self spikeDirectory / 'outside') contents trimBoth asNumber + 4096) ]
