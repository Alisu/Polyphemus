building
damagesIn: aCleanReading

	"What to overwrite, each as address -> word or bytes, or a block giving the word from the
	distance between the reading's addresses and the file's. The class comment names them."

	^ (self damagesOfObjectsIn: aCleanReading) , (self damagesOfContextsIn: aCleanReading)
