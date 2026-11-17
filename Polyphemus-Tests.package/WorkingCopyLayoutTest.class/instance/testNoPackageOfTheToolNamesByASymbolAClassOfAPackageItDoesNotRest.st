tests
testNoPackageOfTheToolNamesByASymbolAClassOfAPackageItDoesNotRest

	"#118: as its sibling, for a class named by a symbol, which is looked up or compared by name:
	the core finding the window's debugger so depended on the windows all the same."

	| organizer found |
	organizer := PolyphemusEdition packageOrganizer.
	found := OrderedCollection new.
	self packagesEachMayName keysAndValuesDo: [ :name :mayName |
		(organizer packageNamed: name ifAbsent: [ nil ]) ifNotNil: [ :package |
			package methods do: [ :method |
				(self symbolsIn: method) do: [ :symbol |
					(Smalltalk globals at: symbol ifAbsent: [ nil ]) ifNotNil: [ :named |
						| its |
						its := named isBehavior
							       ifTrue: [ named instanceSide package name asString ]
							       ifFalse: [ '' ].
						((its beginsWith: 'Polyphemus') and: [ its ~= name and: [ (mayName includes: its) not ] ])
							ifTrue: [
							found add: name , ': ' , method methodClass name , '>>' , method selector , ' names ' , symbol , ' of ' , its ] ] ] ] ] ].
	self assert: found asSortedCollection asArray equals: #(  )
