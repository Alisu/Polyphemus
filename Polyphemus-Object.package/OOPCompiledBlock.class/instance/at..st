accessing
at: anIndex

	"The bytecode at anIndex, as on a reified method -- not the raw byte, which counts from
	the header and answers literals."

	^ self bytecodeAt: anIndex
