stepping
returnValue: anObject from: aContext

	"Returning a value from a frame would rewrite the held image's stack, which is not done from
	here yet; a stack read from a file is left to Pharo's own answer."

	held ifNil: [ ^ super returnValue: anObject from: aContext ].
	^ NotOnAReading signalFor: #returnValue
