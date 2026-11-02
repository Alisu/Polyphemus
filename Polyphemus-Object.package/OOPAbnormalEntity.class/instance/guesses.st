guessing
guesses
	"What the object at the start of this gap may have been, from where it may end and what its
	slots hold (#139)."

	^ self ends flatCollect: [ :each | self guessesEndingAt: each ]
