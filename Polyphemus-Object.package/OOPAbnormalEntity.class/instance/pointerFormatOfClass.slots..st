guessing
pointerFormatOfClass: aClass slots: numSlots
	"The format of an object of aClass with numSlots slots of pointers, or nil if it makes none."

	| instSpec fixed |
	instSpec := memory instSpecOfClass: aClass.
	fixed := memory fixedFieldsOfClass: aClass.
	instSpec = 0 ifTrue: [ ^ numSlots = 0 ifTrue: [ 0 ] ].
	(instSpec = 1 or: [ instSpec = 5 ]) ifTrue: [ ^ fixed = numSlots ifTrue: [ instSpec ] ].
	(instSpec between: 2 and: 4) ifTrue: [ ^ fixed <= numSlots ifTrue: [ instSpec ] ].
	^ nil
