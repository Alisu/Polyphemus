testing
canRead: aLevel

	^ (self refusals includesKey: aLevel) not and: [
		  self refusals keys allSatisfy: [ :failed |
			  (self levels indexOf: failed) > (self levels indexOf: aLevel) ] ]
