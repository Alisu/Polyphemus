testing
canRead: aLevel

	"Readable unless this rung failed, or a rung below it that everything depends on did."

	(self refusals includesKey: aLevel) ifTrue: [ ^ false ].
	^ (self refusals keys anySatisfy: [ :failed |
		   (self globalLevels includes: failed) and: [
			   (self levels indexOf: failed) < (self levels indexOf: aLevel) ] ]) not
