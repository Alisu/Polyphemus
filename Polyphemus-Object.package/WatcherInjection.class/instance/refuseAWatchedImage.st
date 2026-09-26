private
refuseAWatchedImage

	"A watcher of ours already waiting on the semaphore left in that directory is not doubled."

	| file index semaphore |
	file := directory / 'semaphore-index'.
	file exists ifFalse: [ ^ self ].
	index := file contents trimBoth asNumber.
	index > (installer memory numSlotsOf: self externalObjects) ifTrue: [ ^ self ].
	semaphore := installer memory fetchPointer: index - 1 ofObject: self externalObjects.
	semaphore = installer nilOop ifTrue: [ ^ self ].
	(self slot: 'firstLink' of: semaphore in: 'Semaphore') = installer nilOop ifFalse: [
		^ self error: 'that image already has a watcher on ' , directory fullName ]
