semaphore index
watcherVersion

	"A checksum of the watcher's own code: another whenever that code changes, with nothing to
	bump by hand (#163, risk 6)."

	^ ((PolyphemusAgent holdSourceAfterwards: '') , (PolyphemusAgent watcherMethodSourceWatching: '/' asFileReference semaphoreAt: 0))
		  inject: 7 into: [ :sum :each | sum * 31 + each asInteger \\ 16r3FFFFFFF ]
