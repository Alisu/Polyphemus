finding a heap
findYoungMapping

	"VM 10 states a new space apart from old space's mapping, gigabytes below it: kept as a
	mapping of its own, when its end is after its start, held, and within 4 GB of it (#182).
	VM 9 has it just before old space, in the same mapping."

	| start end |
	start := [ vmVariables at: 'newSpaceStart' ] on: Error do: [ ^ self ].
	(start between: mappingStart and: mappingLimit - 1) ifTrue: [ ^ self ].
	(space hasAddress: start) ifFalse: [ ^ self ].
	end := [ vmVariables newSpaceEnd ] on: Error do: [ ^ self ].
	(end > start and: [ end - start <= (1 bitShift: 32) and: [ space hasAddress: end - 1 ] ]) ifFalse: [
		^ self ].
	youngMappingStart := start.
	youngMappingLimit := end