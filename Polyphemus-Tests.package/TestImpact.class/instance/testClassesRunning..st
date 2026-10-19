private
testClassesRunning: aMethod

	"The concrete test classes that run aMethod: its own, and those inheriting it."

	^ aMethod methodClass withAllSubclasses select: [ :each |
		  each isAbstract not and: [ each allTestSelectors includes: aMethod selector ] ]
