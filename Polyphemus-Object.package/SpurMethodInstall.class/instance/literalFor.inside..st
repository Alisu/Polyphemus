literals
literalFor: aValue inside: anOuterOop

	"That literal as an oop of this image: found there when it must be, made there when it
	can be, and refused by name when neither. The outer code is what a block made here will
	belong to."

	aValue isSymbol ifTrue: [ ^ self intern: aValue asString ].
	aValue isString ifTrue: [ ^ self stringFor: aValue ].
	aValue isArray ifTrue: [ ^ self arrayFor: aValue inside: anOuterOop ].
	aValue isVariableBinding ifTrue: [ ^ self bindingFor: aValue ].
	(aValue isKindOf: CompiledBlock) ifTrue: [
		^ self blockFor: aValue inside: anOuterOop ].
	(aValue isKindOf: CompiledCode) ifTrue: [
		^ self error: 'new code naming a whole method of its own is not installed yet' ].
	^ self valueFor: aValue
