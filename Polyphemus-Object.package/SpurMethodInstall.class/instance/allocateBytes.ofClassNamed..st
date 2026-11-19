literals
allocateBytes: aCount ofClassNamed: aString

	"A byte object of that class with room for so many bytes. The class is its hash: #oopClassIndex
	is that plus one, the class table counting from one where a header counts from zero."

	^ self allocateBytes: aCount format: 16 classIndex: (reading oopClassNamed: aString) oopHash
