asking
letGoWithin: aDuration

	"Go is written once the agent serves, or at the deadline all the same: an agent starting later
	looks for it first. Rung only if it serves, so no ring is left behind (#49); answers that."

	| served |
	served := self isServingBefore: DateAndTime now + aDuration.
	directory exists ifFalse: [ ^ false ].
	self write: '' as: 'go'.
	served := served or: [ (directory / 'serving') exists ].
	served ifTrue: [ self ring ].
	^ served
