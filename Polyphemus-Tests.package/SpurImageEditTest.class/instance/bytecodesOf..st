helpers
bytecodesOf: aCompilation

	"Its code, without header, literals or trailer: what an edit writes."

	^ (aCompilation initialPC to: aCompilation endPC) collect: [ :each | aCompilation at: each ]
