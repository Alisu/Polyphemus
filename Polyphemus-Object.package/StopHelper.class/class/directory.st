accessing
directory

	"Where every observer of this user keeps its locks and marks."

	^ (FileLocator temp / 'polyphemus-stop') asFileReference ensureCreateDirectory
