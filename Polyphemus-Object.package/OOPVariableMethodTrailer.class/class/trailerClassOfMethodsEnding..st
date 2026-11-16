recognising
trailerClassOfMethodsEnding: someLastBytes

	"Which trailers methods have, from the last byte of each: variable ones end in a byte naming
	one of the kinds, all of them in the images measured; fixed ones in a byte of a pointer, a
	known kind for about one in five. nil for fewer than twenty methods, or a share in between."

	| known |
	someLastBytes size < 20 ifTrue: [ ^ nil ].
	known := someLastBytes count: [ :each | (self kinds at: each >> 2 + 1) ~~ #Undefined ].
	known * 10 >= (someLastBytes size * 9) ifTrue: [ ^ self ].
	known * 2 <= someLastBytes size ifTrue: [ ^ OOPFixedMethodTrailer ].
	^ nil
