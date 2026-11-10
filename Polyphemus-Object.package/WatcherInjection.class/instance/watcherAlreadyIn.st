private
watcherAlreadyIn

	"Ours waiting on the semaphore left in that directory, or nil when there is none: a slot holding
	no Semaphore, or not our watcher waiting (#163). Refused while ours holds the image (#124)."

	| index semaphore waiting |
	index := (self class semaphoreIndexIn: directory) ifNil: [ ^ nil ].
	index > (installer memory numSlotsOf: self externalObjects) ifTrue: [ ^ nil ].
	semaphore := installer memory fetchPointer: index - 1 ofObject: self externalObjects.
	((semaphore bitAnd: 7) ~= 0 or: [ semaphore = installer nilOop ]) ifTrue: [ ^ nil ].
	(installer memory classIndexOf: semaphore) = (reading oopClassNamed: 'Semaphore') oopHash
		ifFalse: [ ^ nil ].
	waiting := self slot: 'firstLink' of: semaphore in: 'Semaphore'.
	waiting = installer nilOop ifTrue: [
		^ (self class isHoldingIn: directory)
			  ifTrue: [ NotOnAReading signalFor: #watcherWhileHeld ]
			  ifFalse: [ nil ] ].
	^ (self isOurWatcher: waiting) ifTrue: [ waiting ] ifFalse: [ nil ]
