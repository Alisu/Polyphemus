accessing
memory

	"The pinned Pharo 10 image, read once for the class. No test changes it."

	^ Memory ifNil: [ Memory := Polyphemus readImageFile: PharoImageAccessor pathToPharo10 ]
