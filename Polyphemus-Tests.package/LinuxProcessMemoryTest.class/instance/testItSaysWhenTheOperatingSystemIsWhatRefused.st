tests
testItSaysWhenTheOperatingSystemIsWhatRefused

	"The reason this matters: Pharo reports a refused open of `/proc/<pid>/mem` as the file
	not existing, and it does exist -- we are simply not allowed it. Told that it does not
	exist, you would go looking for the wrong thing.

	Skipped where the machine happens to allow it, since then there is nothing to refuse."

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
