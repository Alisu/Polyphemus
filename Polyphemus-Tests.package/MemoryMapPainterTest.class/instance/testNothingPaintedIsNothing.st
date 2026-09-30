tests
testNothingPaintedIsNothing

	"Past the end of what was painted: not free, not anything."

	| painter |
	painter := self painterFor: #( #( 40 1 1 ) ) bytesPerPixel: 8.

	self assert: (painter categoryOfPixel: 3) equals: #nothing
