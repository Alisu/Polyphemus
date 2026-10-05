helpers
launchObservableTarget

	"Launch the pinned target image through bin/pharo-debuggable, not as our descendant,
	waiting on a delay, and answer its pid once its image is loaded and it is idle."

	^ self launchObservableTargetRestartsLeft: 1
