reading registers
mainThreadId

	"The thread created first, which runs Smalltalk (GetThreadTimes: its creation time first)."

	| creation ignored |
	creation := self class pinned: 8.
	ignored := self class pinned: 8.
	^ self threadIds detectMin: [ :each |
		  | thread |
		  thread := self class openThread: 16r0040 inherit: 0 id: each.
		  thread = 0
			  ifTrue: [ SmallInteger maxVal ]
			  ifFalse: [
				  [ (self class timesOf: thread creation: creation exit: ignored kernel: ignored user: ignored) = 0
					    ifTrue: [ SmallInteger maxVal ]
					    ifFalse: [ creation unsignedLongLongAt: 1 ] ] ensure: [ self class closeHandle: thread ] ] ]
