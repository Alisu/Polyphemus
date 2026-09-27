tests
testAClassSideResolvesGlobalsAsItsInstanceSideDoes

	"Pharo 12's compiler asks the metaclass itself for globals, as a class-side method is read."

	| classSide |
	classSide := (reifiedMemory oopClassNamed: 'WeakArray') oopClassSide.

	self
		assert: (classSide bindingOf: #Semaphore) value oopClassName
		equals: 'Semaphore class'.
	self assert: (classSide bindingOf: #NoSuchGlobalAnywhere) isNil
