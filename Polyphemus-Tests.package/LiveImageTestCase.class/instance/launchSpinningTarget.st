helpers
launchSpinningTarget

	"The pinned image, launched observable, wedged and watching. Answers its pid once it says
	it started."

	^ self launchSpinningTargetWarming: false
