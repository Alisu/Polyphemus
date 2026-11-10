asking
request: aSource

	"Every request goes here: the reading it may make stale is told (#168)."

	heldReading ifNotNil: [ :reading | reading noteARequest ].
	^ channel ask: aSource
