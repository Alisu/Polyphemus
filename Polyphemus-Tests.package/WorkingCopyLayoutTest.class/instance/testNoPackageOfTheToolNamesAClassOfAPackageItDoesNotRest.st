tests
testNoPackageOfTheToolNamesAClassOfAPackageItDoesNotRest

	"#118: the tool is packages by role, each resting on those below it. A method of one that
	names a class of a package it does not rest on, a test's or a window's from the core, would
	make it load only in company. Of the packages this image holds."

	| organizer found |
	organizer := PolyphemusEdition packageOrganizer.
	found := OrderedCollection new.
	self packagesEachMayName keysAndValuesDo: [ :name :mayName |
		(organizer packageNamed: name ifAbsent: [ nil ]) ifNotNil: [ :package |
			package methods do: [ :method |
				method referencedClasses do: [ :named |
					| its |
					its := named instanceSide package name asString.
					((its beginsWith: 'Polyphemus') and: [ its ~= name and: [ (mayName includes: its) not ] ])
						ifTrue: [
						found add: name , ': ' , method methodClass name , '>>' , method selector , ' names ' , named name , ' of ' , its ] ] ] ] ].
	self assert: found asSortedCollection asArray equals: #(  )
