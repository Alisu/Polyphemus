tests
testStartingAnImageCannotOutwitYama

	"Starting the target ourselves is the documented way round Yama's ancestor rule, and
	through a shell it does not work: `LibC` can only background a command, the shell exits,
	the child is reparented to init and we are no longer its ancestor.

	Whatever the machine's `ptrace_scope`, the answer is a refusal -- but not the same one.
	Where only ancestors may look, the operating system refuses; where anyone may look, this
	still refuses, because `sleep` is not a Pharo virtual machine and #on: will not hand back
	a reader for something that is not one.

	Both are correct. An earlier version asserted only the first and took the other branch on
	a machine whose scope is 0, where it raised instead of answering -- so it failed for
	somebody else and passed here."

	| raised |
	raised := [ LinuxProcessMemory startAndRead: 'sleep 30'. nil ]
		          on: CannotReadProcess
		          do: [ :error | error ].

	self assert: raised isNotNil.
	self assert: (#( #notAPharoVirtualMachine #noVirtualMachineAppeared
		          #theOperatingSystemRefused #nothingStarted ) includes: raised reason)
