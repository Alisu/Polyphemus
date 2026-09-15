context protocol
home

	"The method activation this one belongs to. For a block activation read from outside we
	cannot follow the closure home, so answer the nearest sender running a method."

	self isBlockContext ifFalse: [ ^ self ].
	^ self findContextSuchThat: [ :each | each isBlockContext not ]
