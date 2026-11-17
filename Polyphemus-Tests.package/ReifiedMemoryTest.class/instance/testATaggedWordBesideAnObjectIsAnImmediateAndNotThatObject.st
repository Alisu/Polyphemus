tests
testATaggedWordBesideAnObjectIsAnImmediateAndNotThatObject

	"#194: a full reading answered the object before a tagged word that fell in its spaces."

	| nilAddress |
	nilAddress := reifiedMemory nilObject.
	self assert: (reifiedMemory reifyOop: nilAddress) address equals: nilAddress.
	#( 1 2 4 ) do: [ :tag |
		self assert: (reifiedMemory reifyOop: nilAddress + tag) isImmediateOop ]
