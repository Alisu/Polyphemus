context protocol
sender

	"The activation that called this one, in whichever form it is in: the frame below on
	this page, or -- for the oldest frame there -- the context that called into the page."

	^ self oopCaller ifNil: [ self oopPageCaller ]
