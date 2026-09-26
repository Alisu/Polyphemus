helpers
launchSpinningTargetWarming: aBoolean

	"The pinned image with our watcher and a process spinning at the priority of a user's own,
	so that it never goes idle."

	^ self launchTargetRunning: (self spinningTargetScriptWarming: aBoolean)
