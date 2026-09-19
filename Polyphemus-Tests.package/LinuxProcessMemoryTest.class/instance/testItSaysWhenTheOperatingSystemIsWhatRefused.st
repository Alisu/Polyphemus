tests
testItSaysWhenTheOperatingSystemIsWhatRefused

	"Pharo reports a refused open of /proc/<pid>/mem as a missing file; it exists, we are just
	not allowed it. Skipped where the machine allows it."

	| other reader |
	other := LinuxProcessMemory pharoProcesses
		         detect: [ :each | (LinuxProcessMemory unchecked: each key) canBeRead not ]
		         ifNone: [ nil ].
	other ifNil: [ ^ self skip: 'every Pharo here can be read; nothing refuses' ].

	reader := [ LinuxProcessMemory on: other key. nil ]
		          on: CannotReadProcess
		          do: [ :error | error ].

	self assert: reader isNotNil.
	self assert: reader reason equals: #theOperatingSystemRefused.
	self assert: (reader messageText includesSubstring: 'ptrace_scope')
