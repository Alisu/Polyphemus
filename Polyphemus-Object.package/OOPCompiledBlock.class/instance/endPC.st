accessing
endPC

	"The last bytecode. Unlike a method, a block has no trailer."

	^ self initialPC + self numberOfBytecodes - 1
