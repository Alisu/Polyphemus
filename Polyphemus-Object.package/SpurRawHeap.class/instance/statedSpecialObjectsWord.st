finding a heap
statedSpecialObjectsWord

	"The word stated for the special objects array, by an image header or a VM's variable,
	whatever it is; nil where nothing states one."

	^ space specialObjectsOop ifNil: [ self stated: 'specialObjectsOop' ]
