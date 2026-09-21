memory
isSmallInteger: anInteger

	"Whether this format holds it in a word: sixty-one bits with its sign."

	^ anInteger >= (0 - (1 bitShift: 60)) and: [ anInteger < (1 bitShift: 60) ]
