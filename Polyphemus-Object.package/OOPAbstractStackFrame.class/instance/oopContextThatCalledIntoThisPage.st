accessing
oopContextThatCalledIntoThisPage

	"Only the oldest frame of a page has one. Every other frame was called by the frame
	below it on the same page, which is what #oopCaller answers."

	^ nil
