tests
testAWatcherTheImageStartsItselfIsNamedAsOurs

	"Else an injection, seeing a waiter that is not named ours, puts a second watcher in (#163)."

	self assert: ((PolyphemusAgent watcherSourceWatching: directory afterwards: '') includesSubstring:
			 'named: ' , WatcherInjection watcherName printString)
