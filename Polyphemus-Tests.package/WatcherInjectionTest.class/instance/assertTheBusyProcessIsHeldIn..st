helpers
assertTheBusyProcessIsHeldIn: aSession

	"The busy process, forked at 40, and when not, which process it was (CI caught one on Pharo
	14, 2026-10-07)."

	(aSession heldProcess ask: self heldIsTheBusyProcess) = 'true' ifTrue: [ ^ self ].
	self fail: 'held instead: ' , (aSession heldProcess ask: self theHeldProcess)
