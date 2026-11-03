accessing
heaps

	"Those still in use."

	^ heaps reject: [ :each | each isNil ]
