private
activeProcessPriority

	stops := stops + 1.
	^ priorities size > 1
		  ifTrue: [ priorities removeFirst ]
		  ifFalse: [ priorities first ]
