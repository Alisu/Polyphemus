reifying
classIsReadableAt: anAddress

	"Whether this address reads as a class: inside the memory, fixed fields and no indexable
	part -- the test #classTableProblemsFrom:upTo: makes of every table entry."

	^ anAddress notNil and: [
		  anAddress ~= 0 and: [
			  ([ self readAt: anAddress through: [ memory formatOf: anAddress ] ]
				   on: PolyphemusError
				   do: [ :e | nil ]) = 1 ] ]
