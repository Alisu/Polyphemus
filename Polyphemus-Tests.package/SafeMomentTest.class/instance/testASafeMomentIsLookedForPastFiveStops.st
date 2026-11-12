tests
testASafeMomentIsLookedForPastFiveStops

	"#31: an image that allocates without pause is caught collecting one stop in three; five in a
	row are no rarity, and the write was refused."

	| stops answer |
	stops := 0.
	answer := memory
		          whileStoppedUnless: [ :variables | (stops := stops + 1) < 9 ifTrue: [ 'collecting garbage' ] ]
		          do: [ #written ].
	self assert: answer equals: #written.
	self assert: stops equals: 9.
	self deny: memory isStopped
