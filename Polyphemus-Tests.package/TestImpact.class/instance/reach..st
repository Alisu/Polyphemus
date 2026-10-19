private
reach: aMethod

	"What to follow from aMethod: a test selects its classes, a resource the tests using it, a
	test class's own method that class; others, their senders, unless everybody implements
	their selector (followed, it would reach everything)."

	| class |
	(self isOurs: aMethod) ifFalse: [ ^ #(  ) ].
	(self isTest: aMethod) ifTrue: [
		tests addAll: (self testClassesRunning: aMethod).
		^ #(  ) ].
	class := aMethod methodClass instanceSide.
	(class inheritsFrom: TestResource) ifTrue: [ ^ self referencesTo: class ].
	((class inheritsFrom: TestCase) and: [ aMethod methodClass isMeta or: [ self isEverybodys: aMethod selector ] ])
		ifTrue: [
			tests addAll: (class withAllSubclasses reject: [ :each | each isAbstract ]).
			^ #(  ) ].
	(seen includes: aMethod selector) ifTrue: [ ^ #(  ) ].
	seen add: aMethod selector.
	^ (self isEverybodys: aMethod selector)
		  ifTrue: [ #(  ) ]
		  ifFalse: [ { aMethod selector } ]
