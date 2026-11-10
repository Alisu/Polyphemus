tests
testPolyphemusRaisesItsErrorsByName

	"#118: a plain self error: can only be caught as any Error. Polyphemus raises a PolyphemusError
	saying what failed; left alone, three methods from before the fork, and the test support."

	| allowed raw |
	allowed := #( 'OOPAbstractEntity class>>on:memory:' 'OOPAbnormalEntity>>couldBeObject:limit:'
	              'AbstractReifiedMemory>>preFindClassNamed:' ).
	raw := OrderedCollection new.
	(Smalltalk allClassesAndTraits select: [ :each |
		 (each package name beginsWith: 'Polyphemus-') and: [
			 (#( 'Tests' 'Helper' 'Builder' ) noneSatisfy: [ :role | each package name includesSubstring: role ])
				 and: [ (each inheritsFrom: TestCase) not ] ] ])
		do: [ :class |
			(class methods , class class methods reject: [ :method | method isFromTrait ]) do: [ :method |
				(method ast sendNodes anySatisfy: [ :node |
					 node selector = #error: and: [ node receiver isSelfVariable ] ]) ifTrue: [
					raw add: method methodClass name , '>>' , method selector ] ] ].
	self assert: (raw reject: [ :each | allowed includes: each ]) asArray sort equals: #(  )
