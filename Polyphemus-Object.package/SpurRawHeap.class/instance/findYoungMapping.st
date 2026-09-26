finding a heap
findYoungMapping

	"VM 10 states a new space apart from old space's mapping, gigabytes below it: kept as a
	mapping of its own. VM 9 has it just before old space, in the same mapping."

	| start |
	start := [ vmVariables at: 'newSpaceStart' ] on: Error do: [ ^ self ].
	(start between: mappingStart and: mappingLimit - 1) ifTrue: [ ^ self ].
	(space hasAddress: start) ifFalse: [ ^ self ].
	youngMappingStart := start.
	youngMappingLimit := vmVariables at: 'newSpaceEnd'
