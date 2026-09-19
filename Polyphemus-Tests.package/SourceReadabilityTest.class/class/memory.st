accessing
memory

	"The linked image, read once for the class: a read takes about fifteen seconds. Its source
	files are looked for again whenever its source rung is, after #forgetWhatWasRead."

	^ Memory ifNil: [ Memory := Polyphemus readImageFile: self directory / 'alone.image' ]
