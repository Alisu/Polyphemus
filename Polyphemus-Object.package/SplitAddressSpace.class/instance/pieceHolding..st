reading
pieceHolding: anAddress

	"The piece holding this address, or nil. The last one found is asked first: a walk reads one
	piece for a long stretch (#152)."

	(last notNil and: [ last hasAddress: anAddress ]) ifTrue: [ ^ last ].
	^ last := pieces detect: [ :each | each hasAddress: anAddress ] ifNone: [ ^ nil ]
