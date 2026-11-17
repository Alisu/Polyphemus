scheduler
processInconsistencies

	"Everything in the process graph a working VM could not have written, as object ->
	problem. Reports and never raises, so it covers the whole image: where the processes cannot
	be listed, that is the one problem, of the special objects the scheduler is found through."

	| problems lists nilObject active unreadable myList queued |
	problems := OrderedCollection new.
	self whyItsProcessesDoNotRead ifNotNil: [
		^ problems
			  add: memory reifiedSpecialObjectArray -> #theRunningProcessDoesNotRead;
			  yourself ].
	nilObject := memory reifiedNilObject.
	active := self reifiedActiveProcess.
	unreadable := Object new.
	queued := OrderedCollection new.
	lists := [ self reifiedProcessLists asArray ]
		         on: PolyphemusError
		         do: [ :e |
			         problems add: active -> #schedulerQueuesAreUnreadable.
			         #(  ) ].

	"the running process is taken out of its queue while it runs"
	myList := memory
		          readSlot: self processMyListSlot
		          of: active
		          ifUnreadable: [ unreadable ].
	myList == unreadable
		ifTrue: [ problems add: active -> #myListIsUnreadable ]
		ifFalse: [
			myList = nilObject ifFalse: [
				problems add: active -> #activeProcessIsQueued ] ].

	lists doWithIndex: [ :list :priority |
		| chain |
		chain := [
		         (self listIsCircular: list) ifTrue: [ problems add: list -> #queueIsCircular ].
		         self processesInList: list ]
			         on: PolyphemusError
			         do: [ :refusal |
				         problems add: list -> #queueIsUnreadable.
				         #(  ) ].
		queued addAll: chain.
		chain ifNotEmpty: [
			(memory readSlot: self listLastLinkSlot of: list ifUnreadable: [ unreadable ])
			= chain last ifFalse: [ problems add: list -> #queueEndsElsewhere ] ].
		chain do: [ :process |
			(memory readSlot: self processMyListSlot of: process ifUnreadable: [ unreadable ])
			= list ifFalse: [ problems add: process -> #notInTheQueueItClaims ].
			(self priorityOf: process)
				ifNil: [ problems add: process -> #priorityIsNotANumber ]
				ifNotNil: [ :its | its = priority ifFalse: [ problems add: process -> #priorityDoesNotMatchItsQueue ] ] ] ].

	"the processes are found by the running one's class: the queues are the other way to them"
	(self isProcess: active ofAnotherClassThanEvery: queued) ifTrue: [
		problems add: active -> #theRunningProcessIsOfAnotherClassThanEveryQueuedOne ].

	self allReifiedProcesses do: [ :process |
		| context |
		(memory readSlot: self processMyListSlot of: process ifUnreadable: [ nilObject ]) isImmediateOop ifTrue: [
			problems add: process -> #myListIsNoList ].
		context := memory
			           readSlot: self processSuspendedContextSlot
			           of: process
			           ifUnreadable: [ unreadable ].
		context == unreadable
			ifTrue: [ problems add: process -> #suspendedContextIsUnreadable ]
			ifFalse: [
				(context = nilObject or: [ context isContextOop ]) ifFalse: [
					problems add: process -> #suspendedContextIsNotAContext ] ] ].

	"listed by a walk over the heap: where damage ended it, those past it are missing (#211)"
	memory whereItsListingsStop ifNotNil: [ :walk |
		problems add: active -> #processesPastWhereTheHeapWalkStoppedAreNotListed ].
	^ problems
