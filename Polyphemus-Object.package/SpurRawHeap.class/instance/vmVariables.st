accessing
vmVariables

	"The VM's own variables, when the space names the VM library it had loaded."

	^ vmVariables ifNil: [ vmVariables := VMVariables on: space ]
