private
processIn: aReading of: aDumpedMemory

	"The process wherever it is, which takes a walk over the whole heap."

	| address |
	address := aDumpedMemory
		           objectOfClassIndex: (aReading oopClassNamed: 'Process') oopHash
		           hash: hash.
	address ifNil: [ ^ self error: 'the image no longer holds that process' ].
	^ aReading reifyOop: address
