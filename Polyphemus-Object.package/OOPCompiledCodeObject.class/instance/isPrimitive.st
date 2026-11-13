testing
isPrimitive

	"The header's primitive flag, its bit 16 counted from 0, as Pharo's hasPrimitive reads it (#184)."

	^ (self methodHeader asInteger bitAt: 17) = 1