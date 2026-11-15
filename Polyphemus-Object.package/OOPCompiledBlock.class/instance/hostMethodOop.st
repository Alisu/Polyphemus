accessing
hostMethodOop

	"The method it is in, through the code it is in when that is a block too. Refused by name
	where that chain ends on no method or comes back on itself (#208)."

	^ memory stacks homeMethodOf: self
