helpers
launchSpinningTarget

	"The target image spinning below the main process's priority, which ends it after ten
	minutes (the test kills it before); its pid. Interval>>do: keeps the loop's frame."

	^ self launchTargetRunning:
		  '[ [ true ] whileTrue: [ (1 to: 1000) do: [ :each | 3 sqrt ] ] ] forkAt: 30.
(Delay forSeconds: 600) wait. Smalltalk exitSuccess'
