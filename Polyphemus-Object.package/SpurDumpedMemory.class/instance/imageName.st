accessing
imageName

	"Polyphemus asks the interpreter for an image name to tell a real image from an empty
	test fixture (`#setUpMode`), and answers the fixture if there is none. A dump is a real
	image's memory, so it says where it came from."

	^ (space respondsTo: #file)
		  ifTrue: [ space file fullName ]
		  ifFalse: [ 'dumped memory' ]
