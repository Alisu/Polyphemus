reading
nameOfCodeAddress: anAddress

	"A trampoline or enilopmart, named from the VM's own variables when they can be read."

	^ [ raw vmVariables nameOfCodeAddress: anAddress ] on: Error do: [ :e | nil ]
