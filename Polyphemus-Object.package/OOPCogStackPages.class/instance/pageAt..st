accessing
pageAt: anAddress

	^ CogStackPageSurrogate64 new address: anAddress simulator: self zoneBase: 0 zoneLimit: 0
