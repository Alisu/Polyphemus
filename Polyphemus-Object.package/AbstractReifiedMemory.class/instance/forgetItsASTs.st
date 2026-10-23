updating
forgetItsASTs

	"Take the methods compiled here for this reading out of Pharo's AST cache: on Pharo 10 and 11
	an entry keeps its key alive through the reading, and the reading is never freed (#110)."

	| cache |
	cache := ASTCache default.
	((cache respondsTo: #removeKey:ifAbsent:) and: [ wrappedVariables notNil ]) ifFalse: [ ^ self ].
	wrappedVariables do: [ :each |
		(each isArray ifTrue: [ each ] ifFalse: [ { each } ]) do: [ :part |
			(part isKindOf: CompiledMethod) ifTrue: [ cache removeKey: part ifAbsent: [ nil ] ] ] ]
