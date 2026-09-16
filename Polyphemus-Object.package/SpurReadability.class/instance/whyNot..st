testing
whyNot: aLevel

	"Why this level cannot be read -- either it failed itself, or something under it did."

	self refusals keysAndValuesDo: [ :failed :reason |
		(self levels indexOf: failed) <= (self levels indexOf: aLevel) ifTrue: [
			^ reason ] ].
	^ nil
