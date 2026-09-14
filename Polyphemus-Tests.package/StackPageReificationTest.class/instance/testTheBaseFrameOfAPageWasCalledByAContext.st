tests
testTheBaseFrameOfAPageWasCalledByAContext

	"A base frame is the oldest frame of its page, not the bottom of the stack. Something
	called it -- it is only the frames that stop here, not the activations.

	A VM does not keep a whole stack as frames. It divorces activations into contexts when
	it needs the room, when a process is suspended, and for every frame when an image is
	written; on loading an image it marries back only what it needs to run. So a page holds
	the newest activations and the rest are contexts, and the oldest frame of a page keeps
	the context that called into it where any other frame keeps its caller's saved
	instruction pointer.

	Here three activations are frames and the fourth, which called them, is still a
	context."

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
