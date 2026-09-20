tests
testTheWrittenImageClimbsTheLadder

	"Read back with the readers a real image gets: bytes, heap, objects, free space, classes
	and the special objects array, with nothing refused."

	| readability |
	readability := Polyphemus readabilityOfImageFile: self written.

	self assert: readability refusals asArray equals: #(  ).
	self assert: readability isFullyReadable
