tests
testARefusalSaysWhatEachSystemWants

	"A process the system would not let us read is explained as that system has it: Linux's Yama
	was given on macOS too, where it is the task port, root and the VM's own pid (#134)."

	| linux macOS windows |
	linux := CannotReadProcess whyTheSystemRefusesOn: 'Linux'.
	macOS := CannotReadProcess whyTheSystemRefusesOn: 'MacOS'.
	windows := CannotReadProcess whyTheSystemRefusesOn: 'Windows'.
	self assert: (linux includesSubstring: 'ptrace_scope').
	self assert: (macOS includesSubstring: 'root').
	self assert: (macOS includesSubstring: 'Pharo.app').
	self deny: (macOS includesSubstring: 'Yama').
	self deny: (windows includesSubstring: 'Yama')
