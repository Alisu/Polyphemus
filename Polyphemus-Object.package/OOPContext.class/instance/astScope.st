context protocol
astScope

	"The scope this frame runs in: the debugger asks it for the temporaries to show, and
	each of those reads its own value back out of this context.

	A method frame runs the method's own scope. A block frame runs one of the block
	scopes inside it, which has to be found first."

	| node |
	node := self analysedMethodNode.
	node ifNil: [ ^ OOPSnapshotScope new ].

	self isBlockContext ifFalse: [ ^ node scope ].

	^ (self blockNodeIn: node)
		  ifNil: [ OOPSnapshotScope new ]
		  ifNotNil: [ :blockNode | blockNode scope ]
