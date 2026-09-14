api
getImage: aNumber
	self getImageVersion: aNumber withName: (self class downloadNameForPharo: aNumber)
