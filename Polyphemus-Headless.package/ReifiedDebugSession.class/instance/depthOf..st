stepping
depthOf: aContext

	"How many frames below the one the debugger is at aContext is, the stack list's selection: a
	context or a frame, known by where it is (#215)."

	| context depth |
	context := self interruptedContext.
	depth := 0.
	[ context activationAddress = aContext activationAddress ] whileFalse: [
		context := context sender.
		context ifNil: [ ^ NotInTheReading signal: 'not a frame of the process being stepped' ].
		depth := depth + 1 ].
	^ depth
