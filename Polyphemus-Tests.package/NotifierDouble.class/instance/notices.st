accessing
notices

	"What it was told, as { message. position }; a position of nil when told without one."

	^ notices ifNil: [ notices := OrderedCollection new ]
