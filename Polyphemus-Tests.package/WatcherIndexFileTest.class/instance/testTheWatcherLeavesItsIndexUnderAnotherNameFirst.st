tests
testTheWatcherLeavesItsIndexUnderAnotherNameFirst

	"Its setup runs in the image watched, its own code: it writes the index as the observer does."

	| interrupt |
	interrupt := Smalltalk compiler evaluate: (PolyphemusAgent watcherSetUpIn: directory) , '
interrupt'.
	[
	self assert: ((PolyphemusAgent watcherSetUpIn: directory) includesSubstring: 'semaphore-index.tmp').
	self assert: (WatcherInjection semaphoreIndexIn: directory) equals: (Smalltalk externalObjects indexOf: interrupt).
	self assert: (directory children collect: [ :each | each basename ]) asArray sort equals: #( 'semaphore-index' 'watcher-version' ) ]
		ensure: [ Smalltalk unregisterExternalObject: interrupt ]
