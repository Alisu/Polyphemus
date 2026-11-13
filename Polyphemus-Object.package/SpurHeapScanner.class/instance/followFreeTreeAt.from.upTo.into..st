reading the free lists
followFreeTreeAt: anAddress from: aStart upTo: aLimit into: aWalk

	"Chunks too large for a list of their own live in a tree, ordered by size, each node with a
	chain of its size. A node seen again, or more chunks than the heap could hold, end it (#182)."

	| pending node seen mostThereCouldBe |
	pending := OrderedCollection new.
	anAddress = 0 ifFalse: [ pending add: anAddress ].
	seen := Set new.
	mostThereCouldBe := aLimit - aStart // 16.
	[ pending isEmpty ] whileFalse: [
		node := pending removeLast.
		((seen includes: node) or: [ aWalk chunkCount > mostThereCouldBe ]) ifTrue: [
			^ aWalk problem: #freeTreeDoesNotEnd at: node ].
		seen add: node.
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