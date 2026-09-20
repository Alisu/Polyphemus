writing
contextOf: aFrame holding: aStackSize

	"The context to fill: the one the frame is married to when its stack fits, or a new one.
	Spur holds a context in 22 slots or in 62 (SmallContextSlots, LargeContextSlots)."

	| slots |
	slots := aStackSize <= 16 ifTrue: [ 22 ] ifFalse: [ 62 ].
	aStackSize > 56 ifTrue: [
		^ self error: 'a stack of ' , aStackSize printString , ' does not fit a context' ].
	(aFrame oopFlag isMarried and: [
		 (dumped memory numSlotsOf: aFrame oopContext address) - 6 >= aStackSize ]) ifTrue: [
		^ aFrame oopContext address ].
	^ self allocateContextOf: slots like: aFrame
