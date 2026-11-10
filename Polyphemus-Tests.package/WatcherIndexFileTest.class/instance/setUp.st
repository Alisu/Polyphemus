running
setUp

	super setUp.
	directory := FileLocator temp / ('polyphemus-index-' , UUID new asString).
	directory ensureCreateDirectory
