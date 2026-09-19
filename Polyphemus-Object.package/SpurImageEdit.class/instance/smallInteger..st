values
smallInteger: anInteger

	"The oop of a SmallInteger, as 64-bit Spur tags it."

	^ (anInteger bitShift: 3) + 1
