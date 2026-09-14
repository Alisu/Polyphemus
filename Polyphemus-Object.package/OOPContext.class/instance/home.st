context protocol
home

	"The method context this one belongs to. For a block activation of a snapshot we
	cannot follow the closure home, so answer the nearest sender running a method."

	self isBlockContext ifFalse: [ ^ self ].
	^ self findContextSuchThat: [ :each | each isBlockContext not ]
