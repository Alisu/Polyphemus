reading
objectAt: aWord

	"As a slot resolves it: reified by address when the walk of new space missed it (#8),
	but only a plausible object in the heap, never a machine code address."

	(memory objectAt: aWord) ifNotNil: [ :object | ^ object ].
	(raw holdsHeapAddress: aWord) ifFalse: [ ^ nil ].
	(raw scanner isPlausibleObjectAt: aWord) ifFalse: [ ^ nil ].
	^ memory reifyOop: aWord
