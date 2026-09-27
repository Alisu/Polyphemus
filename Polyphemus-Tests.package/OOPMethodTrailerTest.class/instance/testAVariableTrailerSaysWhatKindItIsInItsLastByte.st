tests
testAVariableTrailerSaysWhatKindItIsInItsLastByte

	"Up to Pharo 11: a last byte from 252 is a four-byte source pointer; below, its six high
	bits are the kind -- here a source pointer of variable length, and an embedded source."

	| pointer varLength embedded |
	pointer := OOPVariableMethodTrailer on: #[ 16r10 16r04 16r03 16r02 253 ].
	self assert: pointer size equals: 4.
	self assert: pointer sourcePointer equals: 16r02020304.
	self assert: pointer sourceFileIndex equals: 2.
	self assert: pointer sourceFilePosition equals: 16r020304.
	self assert: (OOPVariableMethodTrailer on: #[ 16r10 16r04 16r03 16r02 252 ]) sourceFileIndex equals: 1.
	varLength := OOPVariableMethodTrailer on: #[ 16r10 16r05 16r81 2r00100000 ].
	self assert: varLength size equals: 3.
	self assert: varLength sourcePointer equals: 16r05 << 7 + 16r01.
	embedded := OOPVariableMethodTrailer on: #[ 16r10 97 98 99 3 2r00101100 ].
	self assert: embedded size equals: 5.
	self assert: embedded sourceCode equals: 'abc'.
	self deny: embedded hasSourcePointer
