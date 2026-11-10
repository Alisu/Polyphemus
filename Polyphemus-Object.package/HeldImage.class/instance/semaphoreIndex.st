private
semaphoreIndex

	"Where the watcher registered its semaphore, as it left it in the directory it watches."

	^ (WatcherInjection semaphoreIndexIn: directory) ifNil: [
		  HoldFailed signal: 'nothing watches ' , directory fullName , ': is the image running the watcher?' ]
