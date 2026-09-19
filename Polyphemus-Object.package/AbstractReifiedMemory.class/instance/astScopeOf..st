naming
astScopeOf: anActivation

	"The scope an activation runs: its method's, or for a block activation the block scope
	inside it. The debugger asks it for the temporaries to show."

	| node |
	node := self analysedNodeOf: anActivation.
	node ifNil: [ ^ OOPSnapshotScope new ].

	([ anActivation isBlockContext ] on: Error do: [ :e | false ]) ifFalse: [
		^ node scope ].

	^ (self blockNodeOf: anActivation in: node)
		  ifNil: [ OOPSnapshotScope new ]
		  ifNotNil: [ :blockNode | blockNode scope ]
