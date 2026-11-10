reading processes
processExists: aPid

	^ ('/proc/' , aPid printString) asFileReference exists
