tests
testSuspendedPagesAreReifiedFromTheirHeadFramePointer

	"A live page that is not the active one is reified from its own head frame
	pointer, which the VM wrote back when it left the page. The interpreter's
	registers describe the active page only."

	| activePage |
	activePage := reifiedMemory interpreter stackPages mostRecentlyUsedPage.

	stackPages pages do: [ :journalPage |
		(journalPage isFreePage not and: [ journalPage associatedPage ~= activePage ])
			ifTrue: [
				self
					assert: journalPage frames first framePointer
					equals: journalPage associatedPage headFP ] ]
