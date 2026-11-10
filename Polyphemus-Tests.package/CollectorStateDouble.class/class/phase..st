instance creation
phase: aPhase

	"A VM with no symbol named marking."

	^ self new setValues: (Dictionary new at: 'gcPhaseInProgress' put: aPhase; yourself)
