helpers
launchIdleTarget

	"The edition's target image, as downloaded, idle for a minute on this VM; its pid."

	^ self launchTargetRunning: '(Delay forSeconds: 60) wait. Smalltalk exitSuccess'
