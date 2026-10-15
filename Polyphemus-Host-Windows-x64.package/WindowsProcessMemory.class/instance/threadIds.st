reading registers
threadIds

	"Its threads' ids, from a ToolHelp snapshot of every thread (THREADENTRY32: 28 bytes, the
	thread's id at 8, its process's at 12)."

	| snapshot entry ids more |
	snapshot := self class snapshot: 4 pid: 0.
	entry := self class pinned: 28.
	entry unsignedLongAt: 1 put: 28.
	ids := OrderedCollection new.
	more := (self class firstThread: snapshot into: entry) ~= 0.
	[ more ] whileTrue: [
		(entry unsignedLongAt: 13) = pid ifTrue: [ ids add: (entry unsignedLongAt: 9) ].
		more := (self class nextThread: snapshot into: entry) ~= 0 ].
	self class closeHandle: snapshot.
	^ ids asArray
