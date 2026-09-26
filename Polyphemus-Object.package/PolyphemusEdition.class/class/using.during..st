testing
using: anEdition during: aBlock

	"Behave as that edition for the time of aBlock."

	| previous |
	previous := inUse.
	inUse := anEdition.
	^ aBlock ensure: [ inUse := previous ]
