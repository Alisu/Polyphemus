context protocol
sender

	"The activation that called this one, in whichever form it is in: the frame below on
	this page, or -- for the oldest frame there -- the context that called into the page.

	Only the frames that have one answer #oopCaller; the oldest frame of a page does not
	implement it at all, which is why asking is guarded. Letting that raise cut every stack
	off at its first frame."

	^ ([ self oopCaller ] on: Error, MessageNotUnderstood do: [ :e | nil ])
	  ifNil: [ self oopPageCaller ]
