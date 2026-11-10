instance creation
phase: aPhase marking: aMarking

	^ self new setValues: (Dictionary new at: 'gcPhaseInProgress' put: aPhase; at: 'marking' put: aMarking; yourself)
