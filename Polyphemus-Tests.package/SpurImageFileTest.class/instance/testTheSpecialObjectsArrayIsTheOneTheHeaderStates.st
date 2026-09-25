tests
testTheSpecialObjectsArrayIsTheOneTheHeaderStates

	"On candle another array has the shape searched for -- nil, false, true first -- and was
	taken for it (#43). What the header states is believed when it has that shape."

	| file |
	file := SpurImageFile on: PharoImageAccessor pathToCandle64Bit asFileReference.
	[ self assert: (SpurRawHeap on: file) specialObjectsOop equals: file specialObjectsOop ]
		ensure: [ file close ]
