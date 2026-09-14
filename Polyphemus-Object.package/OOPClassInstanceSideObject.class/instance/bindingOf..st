variables
bindingOf: aName

	"The binding of a name in the image being read, wrapped in a variable object of
	this image so that this image's compiler and highlighter can work with it: they
	only understand their own. The value inside is the reified object from the file.

	Answering nil when the name is absent there is the honest result: binding it to our
	own globals would name a class of this image that merely shares a name."

	| binding |
	binding := memory globalNamed: aName.
	binding ifNil: [ ^ nil ].
	^ LiteralVariable
		  key: aName asString asSymbol
		  value: ([ binding reifiedSlotAt: 2 ] on: Error do: [ :e | binding ])
