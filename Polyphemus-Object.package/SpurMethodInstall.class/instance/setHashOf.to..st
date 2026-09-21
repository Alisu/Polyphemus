memory
setHashOf: anOop to: aHash

	"An identity hash of its own, which a symbol needs: a method dictionary is placed by it."

	^ memory setHashBitsOf: anOop to: aHash
