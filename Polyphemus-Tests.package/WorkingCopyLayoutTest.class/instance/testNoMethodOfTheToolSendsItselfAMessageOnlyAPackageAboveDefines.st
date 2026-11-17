tests
testNoMethodOfTheToolSendsItselfAMessageOnlyAPackageAboveDefines

	"#118: a message sent to self that only an extension of a package above answers is not
	understood once the tool loads without that package. What the core leaves to its edition, its
	host and its VMMaker is theirs to answer: the baseline loads those with it."

	| organizer found |
	organizer := PolyphemusEdition packageOrganizer.
	found := OrderedCollection new.
	self packagesEachMayName keysAndValuesDo: [ :name :mayName |
		(organizer packageNamed: name ifAbsent: [ nil ]) ifNotNil: [ :package |
			package methods do: [ :method |
				(method ast sendNodes select: [ :each | each receiver isVariable and: [ each receiver name = 'self' ] ]) do: [ :send |
					(method methodClass lookupSelector: send selector) ifNotNil: [ :answering |
						| its |
						its := answering package ifNil: [ '' ] ifNotNil: [ :itsPackage | itsPackage name asString ].
						(answering isExtension and: [
							 (its beginsWith: 'Polyphemus') and: [
								 its ~= name and: [ (mayName includes: its) not and: [ (self loadsWithTheCore: its) not ] ] ] ]) ifTrue: [
							found add:
								name , ': ' , method methodClass name , '>>' , method selector , ' sends itself ' , send selector
								, ' of ' , its ] ] ] ] ] ].
	self assert: found asSortedCollection asArray equals: #(  )
