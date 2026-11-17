taking
addMethod: aMethodOop to: aPackageName

	"The method, the blocks among its literals (and theirs), and its AdditionalMethodState."

	| literals |
	(owned includes: aMethodOop) ifTrue: [ ^ self ].
	(self is: aMethodOop named: 'CompiledMethod') ifTrue: [ methodCount := methodCount + 1 ].
	self add: aMethodOop to: aPackageName.
	literals := (objectMemory integerValueOf: (objectMemory fetchPointer: 0 ofObject: aMethodOop)) bitAnd: 16r7FFF.
	1 to: literals do: [ :i |
		| each |
		each := objectMemory fetchPointer: i ofObject: aMethodOop.
		(objectMemory isNonImmediate: each) ifTrue: [
			(objectMemory isCompiledMethod: each)
				ifTrue: [ self addMethod: each to: aPackageName ]
				ifFalse: [
					(self is: each named: 'AdditionalMethodState') ifTrue: [ self add: each to: aPackageName ] ] ] ]
