accessing
sourcePointer

	^ self hasSourcePointer
		  ifTrue: [ data ]
		  ifFalse: [ 0 ]
