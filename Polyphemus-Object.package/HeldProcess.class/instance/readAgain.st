private
readAgain

	"A new copy of the image, read taking the last reading's classes over when it can -- the
	seconds of a reading -- and whole when a GC moved them. The last reading is left as it
	was: the debugger still holds contexts of it."

	| fresh |
	reader whileStopped: [
		fresh := SpurDumpedMemory on: reader.
		fresh raw bytes.
		collections := self collectionsSoFar.
		dumped ifNotNil: [ fresh raw assumeTheHeapOf: dumped raw ] ].
	reading := (dumped notNil and: [ fresh holdsTheClassesOf: dumped ])
		           ifTrue: [ fresh reifiedMemorySharingClassesOf: reading ]
		           ifFalse: [ fresh reifiedMemory ].
	reading editor: self.
	dumped := fresh
