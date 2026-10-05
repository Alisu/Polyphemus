tests
testTheMemoryMapOfADumpShowsNewSpaceAliveAndOldSpaceReadable

	"A process that was running has objects in eden; the map shows them, and nothing of old
	space it cannot read (#68)."

	| picture new old |
	picture := (MemoryMapPresenter on: dumped interpreter objectMemory) picture.
	new := picture painterOf: 1.
	old := picture painterOf: 2.

	self assert: picture sectionLabels equals: #( 'new space' 'old space' ).
	self assert: ((0 to: new geometry pixelCount - 1) anySatisfy: [ :each | (new categoryOfPixel: each) ~= #nothing ]).
	self deny: ((0 to: old geometry pixelCount - 1) anySatisfy: [ :each | (old categoryOfPixel: each) = #unreadable ])
