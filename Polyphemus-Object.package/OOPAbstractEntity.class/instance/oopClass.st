accessing
oopClass

	"The class of this object, or an OOPUnreadableClass naming the index when the table answers
	something that is not a class. The object's slots still read."

	| address |
	address := self oopClassAddress.
	^ (memory classIsReadableAt: address)
		  ifTrue: [ self reifyOop: address ]
		  ifFalse: [
			  OOPUnreadableClass
				  forClassIndex: self oopClassTag
				  at: address
				  on: memory ]
