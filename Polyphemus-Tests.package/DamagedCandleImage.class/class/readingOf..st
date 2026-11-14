reading
readingOf: aFile

	"A full reading of that image file, opened in the simulator as the tests of a snapshot open theirs."

	| reader |
	reader := AbstractInspectorsTest new.
	reader imagePath: aFile fullName.
	reader setUpForResourceMarrying: false.
	^ reader instVarNamed: 'reifiedMemory'
