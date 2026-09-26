private
rangeHolding: anAddress

	"The index of the range anAddress falls in, or nil."

	starts doWithIndex: [ :start :index |
		(anAddress >= start and: [ anAddress - start >> 3 < (slots at: index) size ])
			ifTrue: [ ^ index ] ].
	^ nil
