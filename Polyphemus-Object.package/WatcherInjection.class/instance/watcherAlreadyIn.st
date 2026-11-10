private
watcherAlreadyIn

	"Ours waiting on the semaphore left in that directory, or nil when there is none. Refused when
	that semaphore is there but nobody waits on it: ours is holding the image (#124, #132)."

	| index semaphore waiting |
	index := (self class semaphoreIndexIn: directory) ifNil: [ ^ nil ].
	index > (installer memory numSlotsOf: self externalObjects) ifTrue: [ ^ nil ].
	semaphore := installer memory fetchPointer: index - 1 ofObject: self externalObjects.
	semaphore = installer nilOop ifTrue: [ ^ nil ].
	waiting := self slot: 'firstLink' of: semaphore in: 'Semaphore'.
	waiting = installer nilOop ifTrue: [ ^ NotOnAReading signalFor: #watcherWhileHeld ].
	^ waiting
