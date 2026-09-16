checking
require: aLevel

	"Raise rather than answer something plausible."

	(self canRead: aLevel) ifFalse: [
		^ SpurCannotRead new
			  level: aLevel reason: (self whyNot: aLevel);
			  signal ]
