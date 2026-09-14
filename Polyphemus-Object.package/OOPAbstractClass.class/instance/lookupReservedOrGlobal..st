variables
lookupReservedOrGlobal: aName

	"self, super, thisContext, true, false and nil are the language, not the image: they
	mean the same thing in every image, so this image answers for them. Everything else is
	a name of the image being read and is looked up there.

	nil for a name that is nowhere in that image is the honest answer, and it is the
	compiler's business what to do about it. Ours is not to let it write the name into THIS
	image's Undeclared dictionary, which is done where the analysis is asked for."

	(#( #self #super #thisContext #true #false #nil ) includes:
		 aName asString asSymbol) ifTrue: [
		^ self class environment lookupVar: aName asString asSymbol ].

	^ self bindingOf: aName
