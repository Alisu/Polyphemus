private
ring

	"Count one signal on the agent's own bell, named in bell-index, or on the watcher's semaphore
	before the agent named it; none once it said bell-ended, read as the image is stopped (#137)."

	| channel |
	channel := directory / 'channel'.
	reader whileStopped: [
		(channel / 'bell-ended') exists ifFalse: [
			(SpurWritableProcess on: reader) countOneSignalOnExternalSemaphore:
				((channel / 'bell-index') exists
					 ifTrue: [ (channel / 'bell-index') contents trimBoth asNumber ]
					 ifFalse: [ self semaphoreIndex ]) ] ]
