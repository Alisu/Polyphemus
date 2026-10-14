accessing
boundsOf: aName

	"A SpurNewSpaceSpace (eden, pastSpace, futureSpace): its start -> its limit. Where GCC split
	the struct into its fields (eden.0, eden.1: the Windows VM), from those."

	| start limit |
	[
	start := self addressOf: aName.
	limit := start + 8 ]
		on: SpurCannotRead
		do: [ :e |
			e reason = #theVMLibraryHasNoSuchSymbol ifFalse: [ e pass ].
			(self library addressOf: aName , '.0') ifNil: [ e pass ].
			start := self addressOf: aName , '.0'.
			limit := self addressOf: aName , '.1' ].
	^ (memory unsignedAt: start size: 8) -> (memory unsignedAt: limit size: 8)
