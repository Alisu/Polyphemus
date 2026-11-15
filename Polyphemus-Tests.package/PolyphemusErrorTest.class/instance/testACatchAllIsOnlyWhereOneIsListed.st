tests
testACatchAllIsOnlyWhereOneIsListed

	"#118: a handler of every Error takes a bug of ours for what it guards against. Code that is
	not ours is asked through ForeignCode; elsewhere no method gains one, and a method whose
	handler was narrowed leaves the list."

	| found allowed |
	found := OrderedCollection new.
	self methodsOfPolyphemusDo: [ :method |
		(self catchesAnyError: method) ifTrue: [ found add: method methodClass name , '>>' , method selector ] ].
	allowed := self methodsAllowedACatchAll.

	self assert: (found reject: [ :each | allowed includes: each ]) asArray sort equals: #(  ).
	"Of the listed methods this image holds (a host's or an edition's package may not be loaded),
	each still has its handler; but for one another package defines, which an edition may define
	its own way."
	self
		assert: (allowed select: [ :each |
				 | parts class |
				 parts := each substrings: '>>'.
				 class := (parts first endsWith: ' class')
					          ifTrue: [ (Smalltalk globals at: (parts first allButLast: 6) asSymbol ifAbsent: [ nil ]) ifNotNil: [ :named | named class ] ]
					          ifFalse: [ Smalltalk globals at: parts first asSymbol ifAbsent: [ nil ] ].
				 class notNil and: [
					 (class includesSelector: parts last asSymbol) and: [
						 (class >> parts last asSymbol) isExtension not and: [ (found includes: each) not ] ] ] ]) asArray
		equals: #(  )
