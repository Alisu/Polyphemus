tests
testTheBaseFrameOfAPageWasCalledByAContext

	"A page's base frame keeps the context that called into the page."

	| page base |
	page := stackPages mostRecentlyUsedPage.
	base := page frames last.

	self assert: base isBaseFrame.
	self assert: base savedFramePointer equals: 0.
	self deny: (page frames allButLast anySatisfy: [ :each |
			 each savedFramePointer = 0 ]).

	self
		assert: (reifiedMemory descriptionOfContext: base oopPageCaller)
		equals: 'SessionManager>>snapshot:andQuit: [block]'
