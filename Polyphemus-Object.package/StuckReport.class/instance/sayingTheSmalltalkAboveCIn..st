accessing
sayingTheSmalltalkAboveCIn: aReifiedMemory

	"When its VM is in a C call, say too the Smalltalk process above that call, its frame in C,
	and the first frame below it outside the FFI's own classes (#18). Answers itself."

	| process name stack caller |
	self mainThread isInACCall ifFalse: [ ^ self ].
	process := aReifiedMemory reifiedActiveProcess.
	name := aReifiedMemory processes nameOf: process.
	stack := (aReifiedMemory activationsOfProcess: process) collect: [ :each | each printString ].
	caller := stack allButFirst
		          detect: [ :each | (#( 'TF' 'FFI' ) anySatisfy: [ :prefix | each beginsWith: prefix ]) not ]
		          ifNone: [ nil ].
	self smalltalkAboveC: (name ifNil: [ 'an unnamed process' ] ifNotNil: [ 'process ' , name printString ])
		, (stack ifEmpty: [ '' ] ifNotEmpty: [ ', in ' , stack first ])
		, (caller ifNil: [ '' ] ifNotNil: [ ', called from ' , caller ])