tests
testItsInstructionsSayWhatAHeldVirtualMachineIsAskedToDo

	"Reading leaves a VM as it was; holding it does not, and a client is told so first (#128)."

	| instructions |
	instructions := (PolyphemusMCPServer new initialize: Dictionary new) at: 'instructions'.
	#( 'hold' 'let_go' ) do: [ :each | self assert: (instructions includesSubstring: each) description: each ].
	self deny: (instructions includesSubstring: 'without changing them')
