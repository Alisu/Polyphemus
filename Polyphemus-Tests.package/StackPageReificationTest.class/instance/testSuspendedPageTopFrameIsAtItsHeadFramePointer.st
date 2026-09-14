tests
testSuspendedPageTopFrameIsAtItsHeadFramePointer

	"A live page that is not the active one keeps its own head frame pointer:
	the interpreter's framePointer and stackPointer describe the active page only."

	| vmPages vmPage journalPage |
	vmPages := reifiedMemory interpreter stackPages.
	vmPage := vmPages pages
		          detect: [ :p |
			          p isFree not and: [ p ~= vmPages mostRecentlyUsedPage ] ].
	journalPage := stackPages pages
		               detect: [ :p | p associatedPage = vmPage ].

	self
		assert: journalPage frames first framePointer
		equals: vmPage headFP
