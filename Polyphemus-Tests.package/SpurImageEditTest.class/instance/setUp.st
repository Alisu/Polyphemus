running
setUp

	super setUp.
	written := FileLocator temp / 'polyphemus-edited.image'.
	written ensureDelete
