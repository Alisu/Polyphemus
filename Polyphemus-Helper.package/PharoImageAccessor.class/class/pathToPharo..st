pathFinding
pathToPharo: aNumber

	| path |
	path := self
		        pathToImage: (self nameForPharo: aNumber) , '.image'
		        fetchingWith: [ self getImageForPharo: aNumber ].
	self giveSourcesTheirOwnNameFor: aNumber at: path.
	^ path
