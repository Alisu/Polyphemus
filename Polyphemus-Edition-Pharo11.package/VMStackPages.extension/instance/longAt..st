*Polyphemus-Edition-Pharo11
longAt: byteAddress
	"VMMaker v10.0.5 sends this to its stack pages without defining it; v10.0.0 read it unsigned."

	^ self unsignedLongAt: byteAddress