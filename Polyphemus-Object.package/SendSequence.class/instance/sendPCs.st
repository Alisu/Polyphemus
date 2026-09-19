accessing
sendPCs

	"Each send's offset from the first bytecode."

	^ sends collect: [ :each | each key ]
