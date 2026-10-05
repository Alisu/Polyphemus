helpers
hostMethodOf: aFrame

	"The same method in this image: on the target's own image the host is the same Pharo, so it
	says what the frame's names should be."

	| name |
	name := aFrame homeMethod methodClass name asSymbol.
	^ (Smalltalk globals at: name ifAbsent: [
		   self skip: 'this host has no ' , name , ', so it cannot say how to name its temporaries' ])
	  >> aFrame homeMethod selector
