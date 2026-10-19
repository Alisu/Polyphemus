tools
deepestProcessIn: aReifiedMemory

	"The process with the most to show: most wait in one context, the running one of a dump has
	none, and the one caught saving an image shows only the save, passed over while others are
	there (as the deepest, it hid the code wanted, #92)."

	| stacks candidates |
	stacks := Dictionary new.
	aReifiedMemory allReifiedProcesses do: [ :each |
		stacks at: each put: ([ aReifiedMemory contextsOfProcess: each ] on: Error do: [ :e | #(  ) ]) ].
	candidates := stacks keys reject: [ :each |
		              (stacks at: each) anySatisfy: [ :context |
			              #( #snapshot:andQuit: #doSnapshot ) includes: ([ context selector ] on: Error do: [ :e | nil ]) ] ].
	candidates ifEmpty: [ candidates := stacks keys ].
	^ candidates detectMax: [ :each | (stacks at: each) size ]
