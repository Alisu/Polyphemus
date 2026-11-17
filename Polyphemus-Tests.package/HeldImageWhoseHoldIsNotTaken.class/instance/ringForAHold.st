holding
ringForAHold

	refusesTheRing == true ifTrue: [ ^ HoldFailed signal: 'nothing watches' ].
	^ 42
