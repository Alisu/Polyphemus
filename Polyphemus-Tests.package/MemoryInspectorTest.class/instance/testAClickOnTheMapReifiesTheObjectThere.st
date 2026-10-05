tests
testAClickOnTheMapReifiesTheObjectThere

	"Only that object, as the inspector's memory has it. Old space starts with nil."

	| map address |
	map := (inspector pages detect: [ :each | each title = 'Memory map' ]) retrievePresenter.
	address := (map picture geometryOf: 2) start.

	self assert: (map objectAt: address) identicalTo: (reifiedMemory objectAt: address)
