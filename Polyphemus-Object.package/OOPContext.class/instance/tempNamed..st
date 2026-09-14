context protocol
tempNamed: aName

	"The value of a named temporary, read out of the file.

	A name is not always held by the frame that can see it: a block sees the temporaries of
	the method it was written in, and whether it carries a copy of one, holds a copy of the
	vector one lives in, or has to go and read it where it lives, depends on what the code
	does with it. So each frame is asked to resolve the name itself, and the first one that
	actually holds what it resolved is the one that answers.

	The walk outwards stops on a frame already seen. In an image written by a working VM it
	ends at nil; this one was not necessarily written by a working VM.

	Raises when the value cannot be read, rather than answering nil. nil is a value a
	temporary can genuinely hold, and a debugger that cannot tell 'it is nil' from 'I could
	not read it' is worse than one that says so: the inspector catches this and shows that
	it could not read the variable."

	| name context seen |
	name := aName asString asSymbol.
	context := self.
	seen := OrderedCollection new.
	[ context isNil or: [ seen includes: context ] ] whileFalse: [
		| scope var |
		seen add: context.
		scope := context astScope.
		var := [ scope lookupVar: name ] on: Error do: [ :e | nil ].
		(var notNil and: [ context holds: var inScope: scope ]) ifTrue: [
			^ context readLocal: var ofScope: scope ].
		context := [ context outerContext ] on: Error do: [ :e | nil ] ].

	^ self error: 'no temporary named ' , name asString , ' in this frame'
