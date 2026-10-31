helpers
launchCounter

	^ self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1')
