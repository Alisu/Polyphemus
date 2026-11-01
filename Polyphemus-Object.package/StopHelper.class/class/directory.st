accessing
directory

	"Where every observer of this user keeps its locks and marks."

	^ self madeAt: (FileLocator temp / 'polyphemus-stop') asFileReference
