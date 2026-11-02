testing
canRead: aLevel

	"Readable unless this rung failed, or a rung below it that everything depends on did. Only
	those rungs are checked: another, the walk over every object, cost 17 s on a large heap (#129)."

	(self levels first: (self levels indexOf: aLevel)) do: [ :each |
		((each = aLevel or: [ self globalLevels includes: each ]) and: [ (self reasonFor: each) notNil ])
			ifTrue: [ ^ false ] ].
	^ true
