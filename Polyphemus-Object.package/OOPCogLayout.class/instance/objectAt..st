reading
objectAt: aWord

	"As a slot resolves it: reified by address when the walk of new space missed it (#8),
	but only a plausible object in the heap, never a machine code address."

	(memory objectAt: aWord) ifNotNil: [ :object | ^ object ].
	(aWord between: raw mappingStart and: raw mappingLimit - 1) ifFalse: [ ^ nil ].
	(raw scanner isPlausibleObjectAt: aWord) ifFalse: [ ^ nil ].
	^ memory reifyOop: aWord
