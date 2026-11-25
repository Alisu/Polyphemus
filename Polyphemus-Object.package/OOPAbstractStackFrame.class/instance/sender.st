context protocol
sender

	"The frame below on this page, or for the oldest frame the context that called into the page;
	nil at the bottom of the stack, as a context's sender answers (#215)."

	| caller |
	self oopCaller ifNotNil: [ :frame | ^ frame ].
	caller := self oopPageCaller.
	^ (caller isNil or: [ caller isNilOop ]) ifFalse: [ caller ]
