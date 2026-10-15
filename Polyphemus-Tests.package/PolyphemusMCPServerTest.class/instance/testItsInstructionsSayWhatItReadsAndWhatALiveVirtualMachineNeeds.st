tests
testItsInstructionsSayWhatItReadsAndWhatALiveVirtualMachineNeeds

	"What a client is told first: every kind of memory it reads, and the right a running VM
	takes to look into, on each system."

	| instructions |
	instructions := (PolyphemusMCPServer new initialize: Dictionary new) at: 'instructions'.
	#( 'open_image' 'open_core' 'open_process' 'where_stuck' 'Linux' 'macOS' 'root' ) do: [ :each |
		self assert: (instructions includesSubstring: each) description: each ]
