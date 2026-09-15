naming
astScopeOf: anActivation

	"The scope an activation runs in: the debugger asks it for the temporaries to show, and
	each of those reads its own value back out of the activation.

	A method activation runs the method's own scope. A block activation runs one of the
	block scopes inside it, which has to be found first."

	| node |
	node := self analysedNodeOf: anActivation.
	node ifNil: [ ^ OOPSnapshotScope new ].

	([ anActivation isBlockContext ] on: Error do: [ :e | false ]) ifFalse: [
		^ node scope ].

	^ (self blockNodeOf: anActivation in: node)
		  ifNil: [ OOPSnapshotScope new ]
		  ifNotNil: [ :blockNode | blockNode scope ]
