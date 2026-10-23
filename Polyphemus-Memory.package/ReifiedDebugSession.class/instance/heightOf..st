stepping
heightOf: aContext

	"How many frames aContext has below it: its place in the stack while the ones above come and go."

	| context height |
	context := aContext sender.
	height := 0.
	[ context isNil ] whileFalse: [
		context := context sender.
		height := height + 1 ].
	^ height
