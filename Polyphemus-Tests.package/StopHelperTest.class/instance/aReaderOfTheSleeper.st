helpers
aReaderOfTheSleeper

	"Stopping and resuming need no leave to read, so a sleep will do; Linux's reader is the one made
	with a pid alone, and macOS's stops the same way."

	PolyphemusHost current os = 'Linux' ifFalse: [ self skip ].
	^ PolyphemusMadeFor current processMemoryClass unchecked: target
