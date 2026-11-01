holding it still
resumeItsThreads

	self resumeThroughTheHelperOr: [ LibC system: 'kill -CONT ' , pid printString ]
