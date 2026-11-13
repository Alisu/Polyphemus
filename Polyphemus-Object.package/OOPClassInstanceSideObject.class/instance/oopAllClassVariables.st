classVariables
oopAllClassVariables

	^ self oopClassPoolEntries collect: [ :o | o oopSlotNamed: #value ]
