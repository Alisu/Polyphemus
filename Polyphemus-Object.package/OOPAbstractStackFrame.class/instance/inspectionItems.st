inspection
inspectionItems

	"Its fields, each under its name; one that does not read stands as an OOPUnreadableSlot
	saying why, as a slot of an object does (#198)."

	| items |
	items := {
		         (#method -> (self shown: #method reading: [ self oopMethod ])).
		         (#context -> (self shown: #context reading: [ self oopContext ])).
		         (#flag -> self oopFlag).
		         (#receiver -> (self shown: #receiver reading: [ self oopReceiver ])) } asOrderedCollection.

	items addAll: self inspectionItemsOperandStack.
	items add: #savedIP -> self savedIPDescription.

	^ items
