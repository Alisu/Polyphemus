tests
testAWatcherTheImageStartsItselfSaysItsVersion

	| interrupt |
	interrupt := Smalltalk compiler evaluate: (PolyphemusAgent watcherSetUpIn: directory) , '
interrupt'.
	[ self assert: (WatcherInjection isOfThisVersionIn: directory) ] ensure: [
		Smalltalk unregisterExternalObject: interrupt ]
