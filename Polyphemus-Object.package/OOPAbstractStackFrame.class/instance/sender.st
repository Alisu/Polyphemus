context protocol
sender

	"The frame below on this page, or for the oldest frame the context that called into the page.
	Asking is guarded: the oldest frame has no #oopCaller at all."

	^ ([ self oopCaller ] on: Error, MessageNotUnderstood do: [ :e | nil ])
	  ifNil: [ self oopPageCaller ]
