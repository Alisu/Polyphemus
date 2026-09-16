tests
testItRefusesAProcessThatIsNotThere

	"And says that, rather than that it is not Pharo."

	| raised |
	raised := [ LinuxProcessMemory on: 999999. nil ]
		          on: CannotReadProcess
		          do: [ :error | error ].

	self assert: raised isNotNil.
	self assert: raised reason equals: #noSuchProcess
