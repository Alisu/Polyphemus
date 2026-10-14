tests
testAProcessThatEndedWhileReadIsSaidToBeGone

	"Its task port then answers no region at all: said as no such process, not as a VM whose
	library is not mapped (#79)."

	| pid reader |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	reader := MacProcessMemory on: pid.
	LibC system: 'kill -9 ' , pid printString.
	(1 to: 50) detect: [ :each | reader exists not or: [ (Delay forMilliseconds: 100) wait. false ] ] ifNone: [ nil ].

	self
		should: [ reader mappedFiles ]
		raise: CannotReadProcess
		withExceptionDo: [ :e | self assert: e reason equals: #noSuchProcess ]
