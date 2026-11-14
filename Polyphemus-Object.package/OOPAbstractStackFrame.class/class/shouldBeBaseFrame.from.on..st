assert
shouldBeBaseFrame: anInteger from: somePageBounds on: aPreReifiedMemory

	"The oldest frame of its page saves no frame pointer and, where the page's base is known, is
	at it: a frame elsewhere that saves none is not one (#198)."

	^ (aPreReifiedMemory vmLayout isBaseFrame: anInteger) and: [ somePageBounds isBase: anInteger ]
