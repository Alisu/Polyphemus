literals
literalFor: aValue

	"That literal as an oop of this image: found there when it must be, made there when it
	can be, and refused by name when neither."

	aValue isSymbol ifTrue: [ ^ self intern: aValue asString ].
	aValue isString ifTrue: [ ^ self stringFor: aValue ].
	aValue isArray ifTrue: [ ^ self arrayFor: aValue ].
	aValue isVariableBinding ifTrue: [ ^ self bindingFor: aValue ].
	(aValue isKindOf: CompiledCode) ifTrue: [
		^ self error: 'new code holding a block of its own is not installed yet' ].
	^ self valueFor: aValue
