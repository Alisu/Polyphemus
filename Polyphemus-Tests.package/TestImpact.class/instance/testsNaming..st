private
testsNaming: aClass

	"What to follow from the tests and resources referring to aClass, and from them only; none
	when past wideLimit of them, aClass then said wide: they say nothing of one method of it."

	| naming |
	naming := (SystemNavigation default allReferencesTo: (Smalltalk globals associationAt: aClass name)) select: [ :each |
		          | class |
		          class := each compiledMethod methodClass instanceSide.
		          (class inheritsFrom: TestCase) or: [ class inheritsFrom: TestResource ] ].
	(naming collect: [ :each | each compiledMethod methodClass instanceSide ]) asSet size > self wideLimit
		ifTrue: [
			wide add: aClass name.
			^ #(  ) ].
	^ naming flatCollect: [ :each | self reach: each compiledMethod ]
