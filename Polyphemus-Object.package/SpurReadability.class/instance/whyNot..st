testing
whyNot: aLevel

	"Why this rung cannot be read -- either it failed, or something underneath it that
	everything depends on did."

	(self refusals at: aLevel ifAbsent: [ nil ]) ifNotNil: [ :reason | ^ reason ].
	self refusals keysAndValuesDo: [ :failed :reason |
		((self globalLevels includes: failed) and: [
			 (self levels indexOf: failed) < (self levels indexOf: aLevel) ]) ifTrue: [
			^ reason ] ].
	^ nil
