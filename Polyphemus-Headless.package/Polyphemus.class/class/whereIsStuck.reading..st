reading
whereIsStuck: aPid reading: aReifiedMemory

	"As whereIsStuck:, and when its VM is in a C call, the Smalltalk process above that call, its
	frame in C, and the first frame below it outside the FFI's own classes (#18)."

	| report process name stack caller |
	report := self whereIsStuck: aPid.
	report mainThread isInACCall ifFalse: [ ^ report ].
	process := aReifiedMemory reifiedActiveProcess.
	name := self nameOfProcess: process.
	stack := (aReifiedMemory activationsOfProcess: process) collect: [ :each | each printString ].
	caller := stack allButFirst
		          detect: [ :each | (#( 'TF' 'FFI' ) anySatisfy: [ :prefix | each beginsWith: prefix ]) not ]
		          ifNone: [ nil ].
	report smalltalkAboveC: (name ifNil: [ 'an unnamed process' ] ifNotNil: [ 'process ' , name printString ])
		, (stack ifEmpty: [ '' ] ifNotEmpty: [ ', in ' , stack first ])
		, (caller ifNil: [ '' ] ifNotNil: [ ', called from ' , caller ]).
	^ report
