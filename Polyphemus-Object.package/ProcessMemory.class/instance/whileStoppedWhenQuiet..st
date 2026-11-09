holding it still
whileStoppedWhenQuiet: aBlock

	"As #whileStopped:, stopped at a moment its VM is quiet (#isQuiet): a heap read half way
	through a collection or an allocation reads as damage that is not there. Retried for about
	five seconds, then refused."

	^ self whileStoppedWhenQuiet: aBlock tries: 100
