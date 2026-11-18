tools
close: someArguments

	"Forget a reading and let go of what it reads. A held image is let go or stopped, not closed:
	closing it would leave it held (#180)."

	| reading handle |
	reading := self imageAt: someArguments.
	handle := someArguments at: 'handle'.
	reading isHeld ifTrue: [
		^ ToolCallFailed signal: handle , ' is a held image: let it run on with let_go, or end its process with stop' ].
	reading close.
	self images removeKey: handle.
	^ self text: 'Closed ' , handle , '.' structured: (Dictionary new at: 'handle' put: handle; yourself)
