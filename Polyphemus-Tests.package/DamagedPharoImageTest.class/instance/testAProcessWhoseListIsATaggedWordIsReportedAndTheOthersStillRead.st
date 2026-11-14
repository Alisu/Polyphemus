tests
testAProcessWhoseListIsATaggedWordIsReportedAndTheOthersStillRead

	| watcher problems |
	watcher := DamagedPharoImageResource process: 'SmalltalkImage>>lowSpaceWatcher' in: reifiedMemory.
	problems := reifiedMemory processInconsistencies.

	self assert: reifiedMemory allReifiedProcesses size equals: 8.
	self assert: (problems anySatisfy: [ :each | each key = watcher and: [ each value = #myListIsNoList ] ]).
	self assert: (problems count: [ :each | each value = #myListIsNoList ]) equals: 1.
	self assert: reifiedMemory processStates size equals: 8.
	self assert: (reifiedMemory processStates at: watcher) equals: #unknown
