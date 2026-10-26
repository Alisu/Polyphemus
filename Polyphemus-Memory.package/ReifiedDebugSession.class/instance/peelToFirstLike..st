stepping
peelToFirstLike: aContext

	"Peeling would unwind the held image's stack, which is not done from here yet; a stack read
	from a file is left to Pharo's own answer."

	held ifNil: [ ^ super peelToFirstLike: aContext ].
	^ NotOnAReading signalFor: #peel
