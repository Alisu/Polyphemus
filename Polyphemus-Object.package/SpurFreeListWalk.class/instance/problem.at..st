building
problem: aReason at: anAddress

	"Named, and located. A checker that answers 'corrupt' has told you nothing you can act
	on; one that answers which chunk and what was wrong with it has."

	problems add: aReason -> anAddress
