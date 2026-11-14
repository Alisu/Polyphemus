reading
objectAt: aWord

	"As a slot resolves it: an immediate, or reified by address when the walk of new space missed
	it (#8), but only a plausible object in the heap, never a machine code address."

	(aWord isInteger and: [ memory isImmediate: aWord ]) ifTrue: [ ^ memory reifyOop: aWord ].
	(memory objectAt: aWord) ifNotNil: [ :object | ^ object ].
	(raw holdsHeapAddress: aWord) ifFalse: [ ^ nil ].
	(raw scanner isPlausibleObjectAt: aWord) ifFalse: [ ^ nil ].
	^ memory reifyOop: aWord
