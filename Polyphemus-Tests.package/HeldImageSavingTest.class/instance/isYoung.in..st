helpers
isYoung: anAddress in: aWritableProcess

	| variables |
	variables := aWritableProcess variables.
	^ anAddress >= (variables at: 'newSpaceStart') and: [ anAddress < variables newSpaceEnd ]
