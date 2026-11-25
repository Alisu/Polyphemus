reading
pageHolding: aFramePointer

	"The page in use that aFramePointer is on, from its base to a page's bytes below it, or nil."

	| variables span |
	variables := raw vmVariables.
	span := variables at: 'bytesPerPage'.
	^ variables stackPages
		  detect: [ :each | each baseFP ~= 0 and: [ aFramePointer between: each baseAddress - span and: each baseFP ] ]
		  ifNone: [ nil ]
