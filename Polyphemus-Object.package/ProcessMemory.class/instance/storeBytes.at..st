writing
storeBytes: aByteArray at: anAddress

	"Refused while the process runs: a word set under a running VM lands in the middle of whatever
	it was doing with that word, and it has no way to notice (#24)."

	self isStopped ifFalse: [ ^ CannotWriteThere signal: 'refusing to write to a process that is running' ].
	(self hasAddress: anAddress) ifFalse: [ ^ NotInTheReading signal: 'nothing is mapped at ' , anAddress printStringHex ].
	self write: aByteArray at: anAddress.
	SpurHeapWatch noteWriteInto: self.
	^ aByteArray size
