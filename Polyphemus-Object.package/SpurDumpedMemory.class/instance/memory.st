building the memory
memory

	"A VMMaker memory manager whose view of memory is the dump's, built once."

	^ memory ifNil: [ memory := self buildMemory ]
