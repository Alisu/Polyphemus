reifying
classIsReadableAt: anAddress

	"Whether this address reads as a class: inside the memory, fixed fields and no indexable
	part -- the test #classTableProblemsFrom:upTo: makes of every table entry."

	^ anAddress notNil and: [
		  anAddress ~= 0 and: [
			  ([ memory formatOf: anAddress ] on: Error do: [ :e | nil ]) = 1 ] ]
