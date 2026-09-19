context protocol
compiledCode

	"The method or block this activation runs; nil for a JIT frame this layout cannot read,
	whose method field holds a CogMethod, which is not an object."

	^ self isReadable
		  ifTrue: [ self oopMethod ]
		  ifFalse: [ nil ]
