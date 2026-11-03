accessing
heaps

	"Those still in use, held strongly from here: a weak collection's reject: and collect: answer
	weak ones, whose elements go at the next collection."

	^ (heaps reject: [ :each | each isNil ]) asArray
