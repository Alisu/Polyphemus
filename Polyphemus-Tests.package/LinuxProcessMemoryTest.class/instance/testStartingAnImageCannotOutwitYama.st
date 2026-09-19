tests
testStartingAnImageCannotOutwitYama

	"Starting a target through the shell cannot get round Yama. Either refusal is accepted,
	depending on ptrace_scope."

	| raised |
	raised := [ LinuxProcessMemory startAndRead: 'sleep 30'. nil ]
		          on: CannotReadProcess
		          do: [ :error | error ].

	self assert: raised isNotNil.
	self assert: (#( #notAPharoVirtualMachine #noVirtualMachineAppeared
		          #theOperatingSystemRefused #nothingStarted ) includes: raised reason)
