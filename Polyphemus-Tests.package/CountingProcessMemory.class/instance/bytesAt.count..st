reading
bytesAt: anAddress count: aCount

	reads := self reads + 1.
	^ super bytesAt: anAddress count: aCount
