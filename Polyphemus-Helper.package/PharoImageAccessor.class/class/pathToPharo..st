pathFinding
pathToPharo: aNumber
	| path |
	
	path := self pathToImageNamed: (self nameForPharo: aNumber) , '.image'.
	path asFileReference 
		ifExists: [
			self giveSourcesTheirOwnNameFor: aNumber at: path.
			^ path ]
		ifAbsent: [ 
			self getImageForPharo: aNumber.
			^ self pathToPharo: aNumber ].
