tests
testPolyphemusRaisesItsErrorsByName

	"#118: a plain self error: can only be caught as any Error. Polyphemus raises a PolyphemusError
	saying what failed, in every method of its own, those from before the fork too."

	| raw |
	raw := OrderedCollection new.
	self methodsOfPolyphemusDo: [ :method |
		(method ast sendNodes anySatisfy: [ :node |
			 node selector = #error: and: [ node receiver isSelfVariable ] ]) ifTrue: [
			raw add: method methodClass name , '>>' , method selector ] ].
	self assert: raw asArray sort equals: #(  )
