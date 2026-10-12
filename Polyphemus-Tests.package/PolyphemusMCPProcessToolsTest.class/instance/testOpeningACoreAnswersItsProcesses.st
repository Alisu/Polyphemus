tests
testOpeningACoreAnswersItsProcesses

	| rows |
	self resource core ifNil: [ ^ self skip: 'no core dump here; make one with bin/take-dump.sh' ].
	rows := self processesOf: self resource core.
	self assert: rows notEmpty.
	self assert: (rows anySatisfy: [ :each | (each at: 'depth') > 0 ])
