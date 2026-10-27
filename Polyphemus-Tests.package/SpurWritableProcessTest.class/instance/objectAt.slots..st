helpers
objectAt: anAddress slots: aCount

	"An Array of that many nils (here 0) made at that address."

	process storeWord: (aCount bitShift: 56) + (2 bitShift: 24) + 51 at: anAddress.
	^ anAddress
