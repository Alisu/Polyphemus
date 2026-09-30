tests
testEvaluatingInAPinnedImageLeavesThePinnedFilesAsTheyAre

	"Written images are given sources and changes beside them; the pinned images already have
	theirs, in one directory, and those are left as they are."

	| directory filesThere before |
	directory := PharoImageAccessor pathToPharo10 asFileReference parent.
	filesThere := [
	              ((directory children select: [ :each | #( 'changes' 'sources' ) includes: each extension ])
		               collect: [ :each | each basename -> ([ each size ] on: Error do: [ :e | #unreadable ]) ])
		              asSortedCollection: [ :a :b | a key <= b key ] ] .
	before := filesThere value asArray.

	self evaluate: '3 + 4' in: PharoImageAccessor pathToPharo10 asFileReference.

	self assert: filesThere value asArray equals: before
