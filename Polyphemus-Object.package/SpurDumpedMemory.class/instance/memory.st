building the memory
memory

	"The VMMaker memory manager built from the raw heap, built once."

	^ memory ifNil: [ memory := self buildMemory ]
