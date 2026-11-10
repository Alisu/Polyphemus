context protocol
sender

	"The frame below on this page, or for the oldest frame the context that called into the page."

	^ self oopCaller ifNil: [ self oopPageCaller ]
