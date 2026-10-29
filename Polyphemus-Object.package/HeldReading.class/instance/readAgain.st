private
readAgain

	"A new copy of the image, its machine code and stacks too, taking the last reading's classes
	over when it can. The last reading reads on as it was, the debugger holding contexts of it, but
	for the ASTs Pharo cached of it (#110), however the image ran since (#122)."

	| fresh |
	reader whileStopped: [
		fresh := SpurDumpedMemory on: (ProcessMemoryCopy ofWhatAReadingReads: reader).
		fresh raw bytes.
		collections := self collectionsSoFar.
		dumped ifNotNil: [ fresh raw assumeTheHeapOf: dumped raw ] ].
	reading ifNotNil: [ reading forgetItsASTs ].
	reading := (dumped notNil and: [ fresh holdsTheClassesOf: dumped ])
		           ifTrue: [ fresh reifiedMemorySharingClassesOf: reading ]
		           ifFalse: [ fresh reifiedMemory ].
	reading editor: self.
	dumped := fresh
