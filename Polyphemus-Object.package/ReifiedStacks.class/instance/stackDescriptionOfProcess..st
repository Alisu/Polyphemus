contexts
stackDescriptionOfProcess: aProcessOop

	"The stack of a process as lines of text, top first."

	^ (self contextsOfProcess: aProcessOop) collect: [ :each |
		  self descriptionOfContext: each ]
