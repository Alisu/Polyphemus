frames
stretchesAReadingReads

	"Where a reading reads the image itself, start -> limit: old and new space, Cog's code zone and
	the stack pages, as the VM says now (#122)."

	| stretches |
	stretches := OrderedCollection with: mappingStart -> mappingLimit.
	youngMappingStart ifNotNil: [ stretches add: youngMappingStart -> youngMappingLimit ].
	self codeZone == false ifFalse: [ stretches add: self codeZone ].
	[
	stretches add: (self vmVariables at: 'pages') -> ((self vmVariables at: 'pages') + 1).
	self vmVariables stackPages do: [ :page | stretches add: page baseAddress -> (page baseAddress + 1) ] ]
		on: SpurCannotRead
		do: [ :e | e return: nil ].
	^ stretches
