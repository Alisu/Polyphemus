tests
testItRefusesAProcessThatIsNotPharo

	"Process 1 is whatever started this machine, and it is not a Pharo virtual machine.
	Handing back a reader for it would mean reading some other program's memory as though it
	were a heap, which at best finds nothing and at worst finds something."

	| raised |
	raised := [ LinuxProcessMemory on: 1. nil ]
		          on: CannotReadProcess
		          do: [ :error | error ].

	self assert: raised isNotNil.
	self assert: raised reason equals: #notAPharoVirtualMachine.
	self assert: raised pid equals: 1
