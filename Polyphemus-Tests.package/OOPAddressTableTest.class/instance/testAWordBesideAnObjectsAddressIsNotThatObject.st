tests
testAWordBesideAnObjectsAddressIsNotThatObject

	"#194: the dense table dropped a word's low three bits, and answered the object before it."

	table at: 16r340000008 put: #young.
	#( 1 2 4 7 ) do: [ :offset |
		self assert: (table at: 16r340000008 + offset) isNil ].
	self assert: (table at: 16r340000008) equals: #young
