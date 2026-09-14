highlighting
bytesOfOop: anOopCode

	"The bytecodes of a method or a block of the image being read.

	Read through #bytecodeAt:, never #at:, which means the bytecode at a pc for a method and
	the nth raw byte for a block: a block read the wrong way answers its own header and
	literals, which match nothing and quietly cost every block frame its highlight.

	A compiled block is numbered from its first bytecode and carries no trailer; a method
	says where its code starts and ends, the trailer left out."

	| first last |
	first := [ anOopCode initialPC ] on: Error do: [ :e | 1 ].
	last := [ anOopCode endPC ]
		        on: Error
		        do: [ :e | first + anOopCode numberOfBytecodes - 1 ].
	^ ((first to: last) collect: [ :each | anOopCode bytecodeAt: each ]) asArray
