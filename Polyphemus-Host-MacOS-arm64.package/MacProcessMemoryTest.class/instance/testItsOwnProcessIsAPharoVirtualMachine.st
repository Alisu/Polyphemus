tests
testItsOwnProcessIsAPharoVirtualMachine

	"Known by the VM library it maps, as MacProcessMemory class>>on: checks another process."

	self assert: MacProcessMemory onSelf isPharoVirtualMachine
