reading
bytesAt: anAddress count: aCount

	"All the bytes there, or nil where they are not all here: a probe is no failure, and a walk
	asks millions of times. A space refuses by name only bytes it should have and left out (#212)."

	^ self subclassResponsibility
