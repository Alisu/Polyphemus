tests
testStartingAnImageCannotOutwitYama

	"Starting the target ourselves is the documented way round Yama's ancestor rule, and
	through a shell it does not work: `LibC` can only background a command, the shell exits,
	the child is reparented to init and we are no longer its ancestor.

	That is worth a test because it is a claim about this machine that could change, and
	because the utility's promise is to say *which* of the three things went wrong. Where
	the machine allows reading anyway, the reader comes back and is used."

	| raised reader |
	LinuxProcessMemory ptraceScope = 0 ifTrue: [
		reader := LinuxProcessMemory startAndRead: 'sleep 30'.
		self assert: reader canBeRead.
		LibC system: 'kill ' , reader pid asString.
		^ self ].

	raised := [ LinuxProcessMemory startAndRead: 'sleep 30'. nil ]
		          on: CannotReadProcess
		          do: [ :error | error ].

	self assert: raised isNotNil.
	self
		assert: (#( #notAPharoVirtualMachine #noVirtualMachineAppeared
			     #theOperatingSystemRefused ) includes: raised reason)
