helpers
fix

	"A fix that can both write in place and make room, the image being a file we rewrite."

	^ SpurMethodFix
		  on: reading
		  editing: ((SpurImageEdit on: path)
				   reading: reading;
				   yourself)
		  installing: (SpurMethodInstall on: reading)
