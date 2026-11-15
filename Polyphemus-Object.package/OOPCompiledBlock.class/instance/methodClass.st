debugger protocol
methodClass

	"Its home method's, as for a block of this image: Pharo 10's compiler asks it of the frame code
	runs in (#126). Nil where its home method does not read."

	^ [ self hostMethodOop methodClass ] on: PolyphemusError do: [ :refusal | nil ]
