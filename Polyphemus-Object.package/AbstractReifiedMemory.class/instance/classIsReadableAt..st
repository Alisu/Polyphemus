reifying
classIsReadableAt: anAddress

	"Whether this address can be read as a class: something there, inside the memory, with
	the shape of a class -- fixed fields and no indexable part.

	This is the same test `#classTableProblemsFrom:upTo:` makes of every entry of the table,
	asked one object at a time."

	^ anAddress notNil and: [
		  anAddress ~= 0 and: [
			  ([ memory formatOf: anAddress ] on: Error do: [ :e | nil ]) = 1 ] ]
