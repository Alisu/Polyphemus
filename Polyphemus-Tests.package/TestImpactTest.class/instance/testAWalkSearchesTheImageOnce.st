tests
testAWalkSearchesTheImageOnce

	"#131: ten steps up from a change, each searching every method of the image again, ran past
	the time limit. One pass indexes our methods; each step looks up that index."

	| impact |
	impact := TestImpact fromLines: #( 'SpurHeapScanner walkFrom:upTo:atMost:' 'SpurHeapScanner' ).
	impact testClasses.
	self assert: impact imageSearches equals: 1
