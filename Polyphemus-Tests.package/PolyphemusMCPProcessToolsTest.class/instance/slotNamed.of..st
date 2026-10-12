running
slotNamed: aName of: anInspection

	^ ((anInspection at: 'structuredContent') at: 'slots') detect: [ :each | (each at: 'name') = aName ]
