helpers
launchSpinningTarget

	"The target image spinning below the main process's priority, which ends it after two
	minutes; its pid. Interval>>do: keeps the loop's frame (as in LiveImageTestCase)."

	^ self launchTargetRunning:
		  '[ [ true ] whileTrue: [ (1 to: 1000) do: [ :each | 3 sqrt ] ] ] forkAt: 30.
(Delay forSeconds: 120) wait. Smalltalk exitSuccess'
