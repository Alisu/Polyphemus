tests
testSavedIPOfCallerFrameIsTheCallersSavedIP

	"A frame's saved IP lives in the frame above it, one word above that frame's
	pointer. VMMaker reads the same slot with #frameCallerSavedIP:."

	| frames above caller |
	frames := stackPages mostRecentlyUsedPage frames.
	above := frames first.
	caller := frames second.

	self
		assert: caller savedIP
		equals: (reifiedMemory interpreter frameCallerSavedIP: above framePointer)
