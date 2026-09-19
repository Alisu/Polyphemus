running
setUp

	"Nothing beside the image but what this test puts there."

	super setUp.
	(self class directory files reject: [ :each | each basename = 'alone.image' ]) do: [ :each |
		each ensureDelete ].
	self class memory forgetWhatWasRead
