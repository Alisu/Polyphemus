reading the free lists
followFreeTreeAt: anAddress from: aStart upTo: aLimit into: aWalk

	"Chunks too large for a list of their own live in a tree, ordered by size, and each node
	carries a chain of chunks the same size as itself. Walked with a stack of our own rather
	than by recursion, so a tree that loops costs a bounded amount of time."

	| pending node visits |
	pending := OrderedCollection new.
	anAddress = 0 ifFalse: [ pending add: anAddress ].
	visits := 0.
	[ pending isEmpty ] whileFalse: [
		node := pending removeLast.
		(visits := visits + 1) > 1000000 ifTrue: [
			^ aWalk problem: #freeTreeDoesNotEnd at: node ].
		(node between: aStart and: aLimit)
			ifFalse: [ aWalk problem: #chunkOutsideTheHeap at: node ]
			ifTrue: [
				(self isFreeChunkAt: node)
					ifFalse: [ aWalk problem: #treeHoldsSomethingThatIsNotFree at: node ]
					ifTrue: [
						| smaller larger |
						self
							followFreeChainAt: node
							expecting: nil
							from: aStart
							upTo: aLimit
							into: aWalk.
						smaller := self slotOf: node at: 4.
						larger := self slotOf: node at: 5.
						(smaller notNil and: [ smaller ~= 0 ]) ifTrue: [ pending add: smaller ].
						(larger notNil and: [ larger ~= 0 ]) ifTrue: [ pending add: larger ] ] ] ]
