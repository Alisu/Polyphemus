highlighting
compileHostMethodFor: anActivation

	"The method compiled here, only if it is byte for byte what the file holds."

	| host |
	host := self hostCompilationOf: anActivation.
	host ifNil: [ ^ nil ].
	^ (self host: host matchesOop: anActivation homeMethod)
		  ifTrue: [ host ]
		  ifFalse: [ nil ]
