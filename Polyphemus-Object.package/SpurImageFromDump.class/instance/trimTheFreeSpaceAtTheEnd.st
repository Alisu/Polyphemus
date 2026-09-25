writing
trimTheFreeSpaceAtTheEnd

	"Where the last object ends once collected -- not free space, not the dump's old bridge --
	with the free chunks after it taken off the free lists: they are left out of the image, as
	a snapshot leaves them out (#46)."

	| memory end trailing |
	memory := dumped memory.
	trailing := OrderedCollection new.
	memory allOldSpaceEntitiesDo: [ :each |
		(memory isFreeObject: each)
			ifTrue: [ trailing add: each ]
			ifFalse: [
				(memory isSegmentBridge: each) ifFalse: [
					end := memory addressAfter: each.
					trailing removeAll ] ] ].
	trailing do: [ :each | memory detachFreeObject: each ].
	^ end
