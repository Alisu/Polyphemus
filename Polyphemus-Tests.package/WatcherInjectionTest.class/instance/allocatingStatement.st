helpers
allocatingStatement

	"A loop that allocates without pause: stopped at any moment, its VM is half way through a
	collection one time in four (measured 2026-10-20)."

	^ '| junk | junk := OrderedCollection new. 1 to: 2000 do: [ :i | junk add: (Array new: 50) ]'
