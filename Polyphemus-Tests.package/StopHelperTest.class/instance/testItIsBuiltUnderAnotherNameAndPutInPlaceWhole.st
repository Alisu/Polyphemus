tests
testItIsBuiltUnderAnotherNameAndPutInPlaceWhole

	"Two test images that start at once both built it in place, and one ran what the other was
	still writing: its helper never started, and the stop waited out its bound (#31)."

	| source built |
	source := directory / 'polyphemus-stop.c'.
	StopHelper sourceFile copyTo: source.
	built := StopHelper build: source.
	self assert: built basename equals: 'polyphemus-stop'.
	self assert: (LibC resultOfCommand: '''' , built fullName , ''' > /dev/null 2>&1; echo $?') trimBoth equals: '2'.
	self assert: (directory children collect: [ :each | each basename ]) asSet equals: #( 'polyphemus-stop.c' 'polyphemus-stop' ) asSet
