accessing
outcomeOf: aSelector

	^ (outcomes detect: [ :each | each key selector = aSelector ]) value
