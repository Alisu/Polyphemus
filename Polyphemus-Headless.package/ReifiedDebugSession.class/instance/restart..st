stepping
restart: aContext

	"Restarting a frame would rewrite the held image's stack, which is not done from here yet; a
	stack read from a file has nothing to restart, as Pharo says itself."

	held ifNil: [ ^ super restart: aContext ].
	^ NotOnAReading signalFor: #restart
