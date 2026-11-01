helpers
isStopped

	^ (self stateOf: target) beginsWith: 'T'
