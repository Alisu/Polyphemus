tests
testAClickOnTheMapReifiesTheObjectThere

	"Only that object, as the inspector's memory has it. The map starts with nil."

	| map address |
	map := (inspector pages detect: [ :each | each title = 'Memory map' ]) retrievePresenter.
	address := map picture geometry start.

	self assert: (map objectAt: address) identicalTo: (reifiedMemory objectAt: address)
