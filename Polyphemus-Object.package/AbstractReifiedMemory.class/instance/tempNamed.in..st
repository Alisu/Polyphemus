naming
tempNamed: aName in: anActivation

	"The value of a named temporary, read out of the image.

	A name is not always held by the activation that can see it: a block sees the
	temporaries of the method it was written in, and whether it carries a copy of one, holds
	a copy of the vector one lives in, or has to go and read it where it lives, depends on
	what the code does with it. So each activation is asked to resolve the name itself, and
	the first one that actually holds what it resolved is the one that answers.

	The walk outwards stops on an activation already seen. In an image written by a working
	VM it ends at nil; this one was not necessarily written by a working VM.

	Raises when the value cannot be read, rather than answering nil. nil is a value a
	temporary can genuinely hold, and a debugger that cannot tell 'it is nil' from 'I could
	not read it' is worse than one that says so: the inspector catches this and shows that it
	could not read the variable."

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
