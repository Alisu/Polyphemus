highlighting
code: aHostCode matches: anOopCode

	"Same bytecodes, in the same order, and as many of them."

	^ (self bytesOfHost: aHostCode) = (self bytesOfOop: anOopCode)
