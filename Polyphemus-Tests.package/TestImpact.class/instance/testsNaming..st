private
testsNaming: aClass

	"What to follow from the tests and resources referring to aClass, and from them only; none
	when past wideLimit of them, aClass then said wide: they say nothing of one method of it."

	| naming |
	naming := (self referencesOfOursTo: aClass) select: [ :each |
		          | class |
		          class := each methodClass instanceSide.
		          (class inheritsFrom: TestCase) or: [ class inheritsFrom: TestResource ] ].
	(naming collect: [ :each | each methodClass instanceSide ]) asSet size > self wideLimit
		ifTrue: [
			wide add: aClass name.
			^ #(  ) ].
	^ naming asArray flatCollect: [ :each | self reach: each ]
