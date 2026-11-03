private
literal: aLiteral do: aBlock

	aLiteral isArray ifTrue: [ ^ aLiteral do: [ :each | self literal: each do: aBlock ] ].
	(aLiteral isKindOf: CompiledCode) ifTrue: [
		aBlock value: aLiteral.
		aLiteral messages do: [ :each | aBlock value: each ].
		^ self literalsIn: aLiteral do: aBlock ].
	aBlock value: aLiteral
