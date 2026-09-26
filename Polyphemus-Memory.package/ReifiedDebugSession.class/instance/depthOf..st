stepping
depthOf: aContext

	"How many frames below the one the debugger is at aContext is, the stack list's selection."

	| context depth |
	context := self interruptedContext.
	depth := 0.
	[ context address = aContext address ] whileFalse: [
		context := context sender.
		context ifNil: [ ^ self error: 'not a frame of the process being stepped' ].
		depth := depth + 1 ].
	^ depth
