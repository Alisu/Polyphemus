vm variables
whereTheVMSays: aBlock

	"aBlock's answer, or nil where a VM variable it reads is refused by name (SpurCannotRead at
	#vm). Any other error is a defect, not the VM saying nothing, and goes on (#118)."

	^ aBlock on: SpurCannotRead do: [ :refusal |
		  refusal level = #vm
			  ifTrue: [ nil ]
			  ifFalse: [ refusal pass ] ]
