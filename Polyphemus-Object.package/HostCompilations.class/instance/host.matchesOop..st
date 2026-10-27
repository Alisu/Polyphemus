highlighting
host: aHostCode matchesOop: anOopCode

	"Same bytecodes, in the same order and number. Read through #bytecodeAt:, never #at:, which
	answers a block's raw bytes -- its header and literals."

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
