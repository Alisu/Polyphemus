helpers
launchTargetRunning: aScript

	"The pinned image, launched observable and not as our descendant, running aScript, which
	must leave a file named started in the spike directory. Answers the pid once it has."

	^ self launchTargetRunning: aScript restartsLeft: 1
