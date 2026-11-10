running
setUp

	super setUp.
	directory := FileLocator temp / ('polyphemus-lock-' , UUID new asString).
	directory ensureCreateDirectory
