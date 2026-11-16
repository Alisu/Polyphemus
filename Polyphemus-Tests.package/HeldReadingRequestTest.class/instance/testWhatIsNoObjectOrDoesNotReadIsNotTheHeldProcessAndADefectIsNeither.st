tests
testWhatIsNoObjectOrDoesNotReadIsNotTheHeldProcessAndADefectIsNeither

	"#118: after a collection, what is at the held process's old address may be a forwarder, which
	was asked its hash: a message not understood, caught. It is asked whether it is an object. One
	that does not say its class is not the process; a defect of ours asking is not that."

	| held process |
	held := HeldReading new.
	held instVarNamed: 'hash' put: 77.
	process := [ :className |
	           (DefectiveReadDouble of: Object new)
		           when: #isObjectOop answer: [ true ];
		           when: #oopHash answer: [ 77 ];
		           when: #oopClassName answer: className;
		           yourself ].

	self assert: (held isTheHeldProcess: (process value: [ 'Process' ])).
	self deny: (held isTheHeldProcess: (process value: [ 'Semaphore' ])).
	self deny: (held isTheHeldProcess: OOPForwarder new).
	self deny: (held isTheHeldProcess: (process value: [ NotInTheReading signal: 'its class does not read' ])).
	self should: [ held isTheHeldProcess: (process value: [ 1 / 0 ]) ] raise: ZeroDivide
