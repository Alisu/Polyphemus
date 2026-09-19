highlighting
hostBlockOf: anActivation in: aHostMethod

	"The matching block of aHostMethod, only if its bytecodes are the file block's."

	| candidate |
	candidate := self hostBlockFor: anActivation in: aHostMethod.
	candidate ifNil: [ ^ nil ].
	^ (self host: candidate matchesOop: anActivation compiledCode)
		  ifTrue: [ candidate ]
		  ifFalse: [ nil ]
