inspection
named: aName read: aBlock

	"aBlock's value, something of this code read by name; where it does not read, an
	OOPUnreadableSlot saying why in its place (#206)."

	^ aBlock
		  on: PolyphemusError
		  do: [ :refusal | OOPUnreadableSlot named: aName because: refusal messageText asString on: memory ]
