highlighting
firstBytecodePCOf: aCompiledCodeOop

	"The pc an activation of this code uses for its first bytecode: past the header word and
	the literals. Frames and contexts count their pcs this way."

	^ aCompiledCodeOop numberOfLiterals + 1 * memory wordSize + 1
