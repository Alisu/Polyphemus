reading processes
processExists: aPid

	"Whether a process of that id runs, from a ToolHelp snapshot of every process, which needs
	no right to it (PROCESSENTRY32W: 568 bytes, its id at 8)."

	| snapshot entry found more |
	snapshot := self snapshot: 2 pid: 0.
	entry := self pinned: 568.
	entry unsignedLongAt: 1 put: 568.
	found := false.
	more := (self firstProcess: snapshot into: entry) ~= 0.
	[ more and: [ found not ] ] whileTrue: [
		found := (entry unsignedLongAt: 9) = aPid.
		more := (self nextProcess: snapshot into: entry) ~= 0 ].
	self closeHandle: snapshot.
	^ found
