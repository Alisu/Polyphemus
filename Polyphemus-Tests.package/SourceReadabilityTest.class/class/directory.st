accessing
directory

	"Where the pinned image is linked, alone, so that the sources beside it are what a test
	puts there."

	^ Directory ifNil: [
		  Directory := PolyphemusEdition current scratch / 'polyphemus-source-test'.
		  Directory ensureCreateDirectory.
		  (Directory / 'alone.image') exists ifFalse: [
			  LibC system: 'ln -s ' , PharoImageAccessor pathToPharo10 asFileReference fullName , ' '
				  , (Directory / 'alone.image') fullName ].
		  Directory ]
