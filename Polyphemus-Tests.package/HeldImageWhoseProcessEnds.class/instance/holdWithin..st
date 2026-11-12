holding
holdWithin: aDuration

	self class noteAHold ifTrue: [ ^ ProcessEndedBeforeHeld signal: 'ended before it was held' ]
