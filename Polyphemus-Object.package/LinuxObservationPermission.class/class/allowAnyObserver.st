granting
allowAnyObserver

	"Let any process of this user read this image's memory. The loose setting: use it when the
	observer is not known in advance, and take it back with `#denyObservers` once it is."

	^ self prctlOption: self setPtracerOption argument: -1
