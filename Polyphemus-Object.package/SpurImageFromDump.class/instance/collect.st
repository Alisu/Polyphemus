writing
collect

	"VMMaker's own collection for a snapshot: new space flushed, the unreachable freed, the free
	lists settled. VMMaker v10.0.5 left a 1 halt in scavengeUnfiredEphemeronsInRememberedSet,
	which the built VM runs past: so does this."

	[ dumped memory garbageCollectForSnapshot ]
		on: Halt
		do: [ :halt | halt resume ]
