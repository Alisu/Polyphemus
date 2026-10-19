helpers
graphFor: aSeed

	^ (Smalltalk compiler evaluate: self generatorSource) value: aSeed
