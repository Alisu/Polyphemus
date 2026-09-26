running
setUp

	"New space low, old space a terabyte above, as VM 10 lays them out."

	super setUp.
	table := OOPAddressTable covering: {
			         (16r340000000 -> 16r340000100).
			         (16r10000000000 -> 16r10000000100) }
