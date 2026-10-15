writing
storeWord: aWord at: anAddress

	"Eight bytes, little endian, as #unsignedAt:size: reads them back."

	^ self
		  storeBytes: ((1 to: 8) collect: [ :each | (aWord bitShift: each - 1 * -8) \\ 256 ]) asByteArray
		  at: anAddress
