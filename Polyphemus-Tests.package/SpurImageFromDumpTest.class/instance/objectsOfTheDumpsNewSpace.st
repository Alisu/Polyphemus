helpers
objectsOfTheDumpsNewSpace

	| count |
	count := 0.
	raw youngObjectsDo: [ :each | count := count + 1 ].
	^ count
