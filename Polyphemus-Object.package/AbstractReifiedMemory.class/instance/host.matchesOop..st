highlighting
host: aHostCode matchesOop: anOopCode

	"Same bytecodes, in the same order, and as many of them.

	Read through #bytecodeAt:, never #at:, which means the bytecode at a pc for a method and
	the nth raw byte for a block: a block read the wrong way answers its own header and
	literals, which match nothing."

	| first last ours theirs |
	^ [
	  first := [ anOopCode initialPC ] on: Error do: [ :e | 1 ].
	  last := [ anOopCode endPC ]
		          on: Error
		          do: [ :e | first + anOopCode numberOfBytecodes - 1 ].
	  ours := (first to: last) collect: [ :each | anOopCode bytecodeAt: each ].
	  theirs := (aHostCode initialPC to: aHostCode endPC) collect: [ :each |
		            aHostCode at: each ].
	  ours asArray = theirs asArray ]
		  on: Error
		  do: [ :e | false ]
