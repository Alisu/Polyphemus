helpers
writtenCopyPath

	^ (FileLocator temp / ('polyphemus-watch-' , UUID new printString , '.image')) fullName
