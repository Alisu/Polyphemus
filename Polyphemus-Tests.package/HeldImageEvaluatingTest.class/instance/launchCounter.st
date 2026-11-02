running
launchCounter

	^ self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 41 after: '')
