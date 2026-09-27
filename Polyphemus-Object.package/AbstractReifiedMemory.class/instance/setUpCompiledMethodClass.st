initialization
setUpCompiledMethodClass

	"Slot 17 of the special objects names CompiledMethod up to Pharo 11. Pharo 12 leaves it
	nil, so there it is found by name (#57)."

	| compiledMethodClass |
	compiledMethodClass := memory fetchPointer: 16 ofObject: memory specialObjectsOop.
	compiledMethodClass = memory nilObject ifTrue: [
		^ compiledMethodClassIndex := (self preFindClassNamed: 'CompiledMethod') - 1 ].
	compiledMethodClassIndex := memory rawHashBitsOf: compiledMethodClass
