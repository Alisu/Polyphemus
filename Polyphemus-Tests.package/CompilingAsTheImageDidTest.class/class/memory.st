accessing
memory

	"The pinned Pharo 10 image, read once for the class: a read takes about fifteen seconds.
	Tests that plant compilations in its caches are isolated by #forgetWhatWasRead."

	^ Memory ifNil: [ Memory := Polyphemus readImageFile: PharoImageAccessor pathToPharo10 ]
