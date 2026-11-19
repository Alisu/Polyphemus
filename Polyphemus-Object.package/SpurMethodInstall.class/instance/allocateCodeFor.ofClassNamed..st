literals
allocateCodeFor: aCompiledCode ofClassNamed: aString

	"As allocate:classIndex:, for a block: its code, where a method has its trailer as well."

	^ self allocate: aCompiledCode classIndex: (reading oopClassNamed: aString) oopHash
