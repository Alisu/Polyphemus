assert
shouldBeBaseFrame: anInteger from: aPageOrNil on: aPreReifiedMemory

	"The oldest frame of its page saves no frame pointer and, where the page is known, is at
	the base of it: a frame elsewhere that saves none is not one (#198)."

	^ (aPreReifiedMemory vmLayout isBaseFrame: anInteger) and: [
		  aPageOrNil isNil or: [ aPageOrNil baseFP = anInteger ] ]
