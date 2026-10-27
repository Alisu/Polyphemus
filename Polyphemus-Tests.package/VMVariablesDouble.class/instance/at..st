accessing
at: aName

	^ memory unsignedAt: (self addressOf: aName) size: 8
