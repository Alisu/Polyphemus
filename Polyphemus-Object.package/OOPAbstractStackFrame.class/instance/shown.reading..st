inspection
shown: aName reading: aBlock

	"aBlock's value, a field of this frame; refused, what stands for it where it is shown."

	^ aBlock
		  on: PolyphemusError
		  do: [ :refusal | OOPUnreadableSlot named: aName because: refusal messageText asString on: memory ]
