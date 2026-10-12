running
answer: aDictionary

	"The server's answer to one message, read back from JSON; nil when it answers nothing."

	^ (self server answer: (STONJSON toString: aDictionary)) ifNotNil: [ :line | STONJSON fromString: line ]
