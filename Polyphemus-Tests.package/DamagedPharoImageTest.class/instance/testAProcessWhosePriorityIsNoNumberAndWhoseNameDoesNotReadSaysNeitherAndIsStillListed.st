tests
testAProcessWhosePriorityIsNoNumberAndWhoseNameDoesNotReadSaysNeitherAndIsStillListed

	"#118: the priority of the low space watcher points at an object and its name points nowhere.
	Where a priority was asked as an integer, a message not understood was caught to find out;
	it is asked whether it is one. The process is listed, without a priority and without a name."

	| watcher row |
	watcher := DamagedPharoImageResource process: 'SmalltalkImage>>lowSpaceWatcher' in: reifiedMemory.

	self assert: (reifiedMemory processes priorityOf: watcher) isNil.
	self assert: (Polyphemus nameOfProcess: watcher) isNil.
	self
		assert: (reifiedMemory processes priorityOf: (DamagedPharoImageResource process: 'Process>>resume' in: reifiedMemory)) isInteger.
	row := PolyphemusMCPServer new rowOfProcess: watcher numbered: 1 in: reifiedMemory.
	self assert: (row at: 'priority') isNil.
	self assert: (row at: 'name') isNil.
	self assert: (row at: 'depth') > 0
