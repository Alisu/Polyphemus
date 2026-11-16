accessing
memory

	"The pinned Pharo 10 image, read once for every class of these tests. No test changes it for
	longer than its own run."

	^ Reading ifNil: [ Reading := Polyphemus readImageFile: PharoImageAccessor pathToPharo10 ]
