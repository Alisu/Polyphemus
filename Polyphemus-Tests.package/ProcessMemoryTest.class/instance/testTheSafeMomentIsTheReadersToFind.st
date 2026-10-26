tests
testTheSafeMomentIsTheReadersToFind

	"Putting a watcher in found it, and the hold could not: a reader finds it for whoever writes or
	reads (#118; #98, #113)."

	self deny: (WatcherInjection includesSelector: #whileStoppedAtASafeMoment:).
	self assert: (ProcessMemory includesSelector: #whileStoppedAtASafeMoment:)
