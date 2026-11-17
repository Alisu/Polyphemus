taking
own: aClassOop

	"The class, its method dictionary and its methods, for the class's package."

	| name package dictionary array |
	name := census nameOfClass: aClassOop.
	package := (name endsWith: ' class')
		           ifTrue: [ packageOfClass at: (name allButLast: 6) ifAbsent: [ '(no package)' ] ]
		           ifFalse: [ self packageOfClassOop: aClassOop ].
	packageOfClass at: name put: package.
	self add: aClassOop to: package.
	dictionary := objectMemory fetchPointer: 1 ofObject: aClassOop.
	(self is: dictionary named: 'MethodDictionary') ifFalse: [ ^ self ].
	self add: dictionary to: package.
	array := objectMemory fetchPointer: 1 ofObject: dictionary.
	(objectMemory isNonImmediate: array) ifFalse: [ ^ self ].
	self add: array to: package.
	0 to: (objectMemory numSlotsOf: array) - 1 do: [ :i |
		| method |
		method := objectMemory fetchPointer: i ofObject: array.
		((objectMemory isNonImmediate: method) and: [ objectMemory isCompiledMethod: method ]) ifTrue: [
			self addMethod: method to: package ] ]
