variables
lookupReservedOrGlobal: aName

	"The pseudo-variables answer for themselves; any other name is looked up in the image
	being read, and nil when it is not there."

	(#( #self #super #thisContext #true #false #nil ) includes:
		 aName asString asSymbol) ifTrue: [
		^ self class environment lookupVar: aName asString asSymbol ].

	^ self bindingOf: aName
