literals
largeIntegerFor: anInteger

	"An integer too big for a word, as the image holds one: its bytes, least significant
	first, under the class its sign asks for."

	| magnitude bytes oop |
	magnitude := anInteger abs.
	bytes := OrderedCollection new.
	[ magnitude > 0 ] whileTrue: [
		bytes add: magnitude \\ 256.
		magnitude := magnitude // 256 ].
	bytes ifEmpty: [ bytes add: 0 ].
	oop := self
		       allocateBytes: bytes size
		       ofClassNamed: (anInteger negative
				        ifTrue: [ 'LargeNegativeInteger' ]
				        ifFalse: [ 'LargePositiveInteger' ]).
	bytes doWithIndex: [ :each :index | memory byteAt: oop + 8 + index - 1 put: each ].
	^ oop
