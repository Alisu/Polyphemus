helpers
launchTargetRunning: aScript

	"The edition's target image, as downloaded, running aScript on this VM, as the observee user
	under sudo (observeeUser), from a directory of its own; its pid."

	^ self launchTargetRunning: aScript withAWindow: false
