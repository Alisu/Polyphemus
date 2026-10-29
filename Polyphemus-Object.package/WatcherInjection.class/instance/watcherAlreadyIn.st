private
watcherAlreadyIn

	"Ours waiting on the semaphore left in that directory, or nil when there is none. Refused when
	that semaphore is there but nobody waits on it: ours is holding the image (#124)."

	| file index semaphore waiting |
	file := directory / 'semaphore-index'.
	file exists ifFalse: [ ^ nil ].
	index := file contents trimBoth asNumber.
	index > (installer memory numSlotsOf: self externalObjects) ifTrue: [ ^ nil ].
	semaphore := installer memory fetchPointer: index - 1 ofObject: self externalObjects.
	semaphore = installer nilOop ifTrue: [ ^ nil ].
	waiting := self slot: 'firstLink' of: semaphore in: 'Semaphore'.
	waiting = installer nilOop ifTrue: [
		^ self error: 'that image is held right now through ' , directory fullName
			  , ': close its debugger, or let it go, first' ].
	^ waiting
