tests
testPolyphemusSignalsNoErrorOfAnotherName

	"#118: an Error, a SubscriptOutOfBounds or a NotFound signalled by Polyphemus reads as any
	other code's; what it signals itself is a PolyphemusError."

	| root others |
	root := Smalltalk globals at: #PolyphemusError.
	others := OrderedCollection new.
	self methodsOfPolyphemusDo: [ :method |
		(method ast sendNodes anySatisfy: [ :node |
			 (#( #signal #signal: #signalFor: #signalFor:in: #new ) includes: node selector) and: [
				 node receiver isVariable and: [
					 (Smalltalk globals at: node receiver name ifAbsent: [ nil ]) in: [ :named |
						 named isClass and: [ (named includesBehavior: Error) and: [ (named includesBehavior: root) not ] ] ] ] ] ])
			ifTrue: [ others add: method methodClass name , '>>' , method selector ] ].
	self assert: others asArray sort equals: #(  )
