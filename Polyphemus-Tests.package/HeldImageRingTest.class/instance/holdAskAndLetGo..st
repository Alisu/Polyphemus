helpers
holdAskAndLetGo: aPid

	"A hold whose agent answered and ended, its watcher waiting again: answers its watcher's index."

	| image |
	image := HeldImage on: aPid watchedIn: self spikeDirectory.
	image holdWithin: 1 minute.
	self assert: (image process ask: '3 + 4') equals: '7'.
	image letGo.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'never let go'.
	^ image semaphoreIndex
