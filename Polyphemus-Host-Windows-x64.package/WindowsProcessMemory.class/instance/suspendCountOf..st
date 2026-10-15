holding it still
suspendCountOf: anId

	"How many times that thread is suspended, read by suspending it once more and letting it
	go; nil when it cannot be opened."

	| thread count |
	thread := self class openThread: 16r0002 inherit: 0 id: anId.
	thread = 0 ifTrue: [ ^ nil ].
	count := self class suspendThread: thread.
	count = 16rFFFFFFFF ifFalse: [ self class resumeThread: thread ].
	self class closeHandle: thread.
	^ count = 16rFFFFFFFF ifTrue: [ nil ] ifFalse: [ count ]
