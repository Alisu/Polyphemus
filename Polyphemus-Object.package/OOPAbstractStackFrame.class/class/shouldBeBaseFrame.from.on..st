assert
shouldBeBaseFrame: anInteger from: somePageBounds on: aPreReifiedMemory

	"The oldest frame of its page saves no frame pointer and, where the page's base is known, is
	at it: a frame elsewhere that saves none is not one (#198). One whose saved frame pointer does
	not read is not taken for it either."

	^ ([ aPreReifiedMemory vmLayout isBaseFrame: anInteger ] on: NotInTheReading do: [ :refusal | false ])
		  and: [ somePageBounds isBase: anInteger ]
