tests
testOnlyTheWindowsPackageNamesPharosWindows

	"#118: the core, what works without a window and the MCP server load where there is no
	screen. None of their methods names a class of Spec, of Pharo's tools or of Morphic, nor is a
	tab of the inspector: those are extensions in Polyphemus-Memory."

	| organizer found |
	organizer := PolyphemusEdition packageOrganizer.
	found := OrderedCollection new.
	(self packagesEachMayName keys reject: [ :each | each = 'Polyphemus-Memory' ]) do: [ :name |
		(organizer packageNamed: name ifAbsent: [ nil ]) ifNotNil: [ :package |
			package methods do: [ :method |
				(method hasPragmaNamed: #inspectorPresentationOrder:title:) ifTrue: [
					found add: name , ': ' , method methodClass name , '>>' , method selector , ' is a tab of the inspector' ].
				method referencedClasses do: [ :named |
					| its |
					its := named instanceSide package name asString.
					(#( 'Spec2' 'NewTools' 'Morphic' 'Polymorph' 'Rubric' ) anySatisfy: [ :each | its beginsWith: each ]) ifTrue: [
						found add: name , ': ' , method methodClass name , '>>' , method selector , ' names ' , named name , ' of ' , its ] ] ] ] ].
	self assert: found asSortedCollection asArray equals: #(  )
