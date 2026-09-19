naming
tempNamed: aName in: anActivation

	"The value of a named temporary, from the first activation outwards that holds it. Raises
	when it cannot be read, because nil is a real value."

	| name current seen |
	name := aName asString asSymbol.
	current := anActivation.
	seen := OrderedCollection new.
	[ current isNil or: [ seen includes: current ] ] whileFalse: [
		| scope var |
		seen add: current.
		scope := self astScopeOf: current.
		var := [ scope lookupVar: name ] on: Error do: [ :e | nil ].
		(var notNil and: [ self activation: current holds: var inScope: scope ])
			ifTrue: [ ^ self read: var ofScope: scope in: current ].
		current := [ current outerContext ] on: Error do: [ :e | nil ] ].

	^ self error: 'no temporary named ' , name asString , ' in this frame'
