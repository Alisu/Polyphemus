accessing
oneOf: someHostClasses

	"The host's class when there is exactly one; refused by name with none, and with several."

	someHostClasses ifEmpty: [
		^ NotSetUp signal: 'No Polyphemus-Host package is loaded: the baseline has none for '
			  , PolyphemusHost current metacelloAttribute ].
	someHostClasses size > 1 ifTrue: [
		^ NotSetUp signal: 'Several Polyphemus-Host packages are loaded, where one is this host''s: '
			  , (', ' join: (someHostClasses collect: [ :each | each name ]) asSortedCollection) ].
	^ someHostClasses first
