variables
lookupReservedOrGlobal: aName

	"self, super, thisContext, true, false and nil are the language, not the image: they
	mean the same thing in every image, so this image answers for them. Everything else
	is a name of the image being read and is looked up there."

	(#( #self #super #thisContext #true #false #nil ) includes: aName asString asSymbol)
		ifTrue: [ ^ self class environment lookupVar: aName asString asSymbol ].

	^ self bindingOf: aName
