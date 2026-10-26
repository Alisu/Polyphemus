running
setUp

	super setUp.
	workspace := Dictionary new.
	Smalltalk compiler receiver: workspace; evaluate: PolyphemusAgent helpersSource
