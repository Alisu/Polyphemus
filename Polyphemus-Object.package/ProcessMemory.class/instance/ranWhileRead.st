holding it still
ranWhileRead

	"Refuse what was read: the stop ended at its bound before the reading did, so it ran meanwhile."

	^ (SpurCannotRead new level: #bytes reason: #itRanWhileRead) signal
