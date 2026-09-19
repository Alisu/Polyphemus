testing
require: aLevel

	(self canRead: aLevel) ifFalse: [
		^ SpurCannotRead new
			  level: aLevel reason: (self whyNot: aLevel);
			  signal ]
