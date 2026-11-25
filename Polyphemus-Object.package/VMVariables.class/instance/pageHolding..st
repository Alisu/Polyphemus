accessing
pageHolding: aFramePointer

	"The page in use that aFramePointer is on, from its base to a page's bytes below it, or nil."

	| span |
	span := self at: 'bytesPerPage'.
	^ self stackPages
		  detect: [ :each | each baseFP ~= 0 and: [ aFramePointer between: each baseAddress - span and: each baseFP ] ]
		  ifNone: [ nil ]
