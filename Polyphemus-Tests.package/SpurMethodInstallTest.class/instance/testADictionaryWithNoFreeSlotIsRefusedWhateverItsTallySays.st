tests
testADictionaryWithNoFreeSlotIsRefusedWhateverItsTallySays

	"#163, item 12: the place of a new method is probed for from the selector's hash to the first
	free slot. A dictionary with none, whose tally says it has room (damaged, or half written),
	was probed for ever, the image stopped meanwhile; it is refused."

	| integer compilation install symbol memory dictionary size outcome |
	integer := reading oopClassNamed: 'Integer'.
	compilation := (reading compileHostSource: 'neverPlaced ^ 42' for: integer) first.
	install := SpurMethodInstall on: reading.
	symbol := install intern: 'neverPlaced'.
	memory := install memory.
	dictionary := (integer reifiedSlotAt: 2) address.
	size := memory numSlotsOf: ((integer reifiedSlotAt: 2) reifiedSlotAt: 2) address.
	1 to: size do: [ :index |
		(memory fetchPointer: index + 1 ofObject: dictionary) = reading reifiedNilObject address ifTrue: [
			memory storePointer: index + 1 ofObject: dictionary withValue: symbol ] ].
	memory storePointer: 0 ofObject: dictionary withValue: (memory smallIntegerOop: 0).

	outcome := [
	           [
	           install install: compilation under: symbol in: integer.
	           #placed ]
		           on: CannotWriteThere
		           do: [ :refusal | #refused ] ]
		           valueWithin: 10 seconds
		           onTimeout: [ #probedForEver ].
	self assert: outcome equals: #refused
