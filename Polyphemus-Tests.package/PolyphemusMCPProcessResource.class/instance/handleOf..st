running
handleOf: aResult

	^ ((aResult at: 'structuredContent' ifAbsent: [ ^ self error: ((aResult at: 'content') first at: 'text') ]) at: 'handle')
