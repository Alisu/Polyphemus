helpers
frameDescribed: aDescription

	^ self allFrames detect: [ :each |
		  (reifiedMemory descriptionOfContext: each) = aDescription ]
