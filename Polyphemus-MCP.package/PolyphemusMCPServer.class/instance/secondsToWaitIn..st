tools
secondsToWaitIn: someArguments

	"How long run_until lets the image run: 60 seconds if not said, one at least, 600 at most,
	since the server answers nothing while it waits (#180)."

	| seconds |
	seconds := someArguments at: 'seconds' ifAbsent: [ 60 ].
	seconds isNumber ifFalse: [ ^ ToolCallFailed signal: 'run_until takes its seconds as a number' ].
	^ (seconds max: 1) min: 600