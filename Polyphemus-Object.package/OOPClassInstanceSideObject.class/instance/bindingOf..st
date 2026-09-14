variables
bindingOf: aName

	"The binding of a name in the image being read, wrapped in a variable object of this
	image so that this image's compiler and highlighter can work with it: they only
	understand their own. The value inside is the reified object from the file.

	It has to be a GlobalVariable and not merely a LiteralVariable, which is its
	superclass: the syntax highlighter asks a variable whether it is a global, and one that
	says no is painted as a name that resolves to nothing.

	It also has to be the same object every time the name is asked for, which is why the
	memory keeps it. A name has one binding over there, and code that mentions it twice
	mentions one object.

	Answering nil when the name is absent there is the honest result: binding it to our own
	globals would name a class of this image that merely shares a name."

	| binding |
	binding := memory globalNamed: aName.
	binding ifNil: [ ^ nil ].
	^ memory
		  wrappedVariableAt: 'global.' , aName asString
		  ifAbsentPut: [
			  GlobalVariable
				  key: aName asString asSymbol
				  value: ([ binding reifiedSlotAt: 2 ] on: Error do: [ :e | binding ]) ]
