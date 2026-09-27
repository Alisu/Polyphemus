accessing
againOf: aSelector

	"What the test did when run once more, nil unless it had failed or raised an error."

	^ again keys
		  detect: [ :each | each selector = aSelector ]
		  ifFound: [ :test | again at: test ]
		  ifNone: [ nil ]
