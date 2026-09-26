reifying
reifyMemoryThroughRoots

	"For now take all already reified objects as Roots, may be changed in the future cause it add a lot of redundancy"

	| visitor |
	visitor := OOPObjectMissingSubgraphVisitor new.
	visitor memory: self.
	objectsArray do: [ :aRoot |
		(aRoot notNil and: [ aRoot address <= lastKnownObject address ]) ifTrue: [
			visitor
				rootObject: aRoot;
				compute ] ]
