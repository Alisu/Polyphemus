helpers
fix

	"A fix that can both write in place and make room, the image being a file we rewrite."

	^ SpurMethodFix
		  on: reading
		  editing: (SpurEdit on: (SpurWritableImageFile on: path) reading: reading)
		  installing: (SpurMethodInstall on: reading)
