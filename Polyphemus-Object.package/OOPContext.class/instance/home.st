context protocol
home

	"The method activation this one belongs to. For a block activation read from outside we
	cannot follow the closure home: the nearest sender running a method, or itself when the stack
	is cut before one, still on the VM's stack pages (#149)."

	self isBlockContext ifFalse: [ ^ self ].
	^ (self findContextSuchThat: [ :each | each isBlockContext not ]) ifNil: [ self ]
