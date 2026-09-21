memory
slot: anIndex of: anOop

	"One slot of an object, counting from zero as the machine does."

	^ self wordAt: anOop + 8 + (anIndex * 8)
