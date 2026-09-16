accessing
oopClass

	"The class of this object -- or, when the class table answers something that is not a
	class, an `OOPUnreadableClass` saying which index failed.

	The object itself is untouched by that: its slots, its size and its contents are all
	still readable. Only the name is missing, and a reader is better told that plainly than
	handed whatever happened to sit at the address."

	| address |
	address := self oopClassAddress.
	^ (memory classIsReadableAt: address)
		  ifTrue: [ self reifyOop: address ]
		  ifFalse: [
			  OOPUnreadableClass
				  forClassIndex: self oopClassTag
				  at: address
				  on: memory ]
