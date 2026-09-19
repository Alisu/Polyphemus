simulator protocol
surrogateAtAddress: anAddress

	"What a page's nextPage and prevPage answer."

	anAddress = 0 ifTrue: [ ^ nil ].
	^ self pageAt: anAddress
