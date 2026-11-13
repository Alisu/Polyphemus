initialization
holdSegmentsToTheFile

	"A dump cut short (a full disk, a ulimit) holds less than its headers promise: each region
	keeps what the file holds, and the cut is noted (#182)."

	| fileSize held cut |
	fileSize := file size.
	held := segments collect: [ :each | each heldInAFileOf: fileSize ].
	cut := (1 to: segments size) count: [ :index |
		       (held at: index) sizeInFile < (segments at: index) sizeInFile ].
	segments := held.
	cutShort := cut = 0 ifFalse: [
		            'the file ends at byte ' , fileSize printString , ', before the end of '
		            , cut printString , ' of its regions' ]