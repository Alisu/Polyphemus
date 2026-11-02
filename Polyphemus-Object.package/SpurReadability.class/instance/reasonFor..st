checking
reasonFor: aLevel

	"Why that rung alone cannot be read, nil if it can: checked once."

	checked ifNil: [ checked := Dictionary new ].
	^ (checked at: aLevel ifAbsentPut: [ { (self whyCannotRead: aLevel) } ]) first
