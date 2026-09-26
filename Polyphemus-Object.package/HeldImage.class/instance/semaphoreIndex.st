private
semaphoreIndex

	"Where the watcher registered its semaphore, as it left it in the directory it watches."

	| file |
	file := directory / 'semaphore-index'.
	file exists ifFalse: [
		^ self error: 'nothing watches ' , directory fullName , ': is the image running the watcher?' ].
	^ file contents trimBoth asNumber
