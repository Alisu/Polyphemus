source
semaphoreAt: anIndex

	"How the image names the watcher's semaphore: its place in the external objects table,
	which the VM signals from outside the interpreter (signalSemaphoreWithIndex)."

	^ '(Smalltalk externalObjects at: ' , anIndex printString , ')'
