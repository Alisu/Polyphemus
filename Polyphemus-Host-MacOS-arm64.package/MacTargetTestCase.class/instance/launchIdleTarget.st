helpers
launchIdleTarget

	"The edition's target image, as downloaded, idle for ten minutes on this VM (the test kills it); its pid."

	^ self launchTargetRunning: '(Delay forSeconds: 600) wait. Smalltalk exitSuccess'
