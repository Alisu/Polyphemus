accessing
pageAt: anAddress

	^ self class surrogateClass new address: anAddress simulator: self zoneBase: 0 zoneLimit: 0
