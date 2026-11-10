accessing
directory

	"Where observers keep their locks and marks: one for every user where the helper runs (#163);
	this user's own while another user's makes it closed to it (Pharo's temp is /tmp for all)."

	^ Smalltalk os isWindows
		  ifTrue: [ self madeAt: (FileLocator temp / 'polyphemus-stop') asFileReference ]
		  ifFalse: [
			  self
				  directoryShared: self sharedDirectory
				  else: (FileLocator temp / ('polyphemus-stop-' , (Smalltalk os environment at: 'USER' ifAbsent: [ 'user' ]))) asFileReference ]
