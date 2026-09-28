helpers
launchFlagTarget

	"A target running away while the first slot of its flag is 1, and saying so once it stops."

	^ self launchFlagTargetLooping: '(1 to: 1000) do: [ :each | flag size. 3 sqrt ]'
