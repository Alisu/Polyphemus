scheduler
processInconsistencies

	"Everything in the process graph a working VM could not have written, as object ->
	problem. Reports and never raises, so it covers the whole image: where the processes cannot
	be listed, that is the one problem, of the special objects the scheduler is found through."

	| problems lists nilObject active unreadable myList |
	problems := OrderedCollection new.
	self whyItsProcessesDoNotRead ifNotNil: [
		^ problems
			  add: memory reifiedSpecialObjectArray -> #theRunningProcessDoesNotRead;
			  yourself ].
	nilObject := memory reifiedNilObject.
	active := self reifiedActiveProcess.
	unreadable := Object new.
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
		chain ifNotEmpty: [
			(memory readSlot: self listLastLinkSlot of: list ifUnreadable: [ unreadable ])
			= chain last ifFalse: [ problems add: list -> #queueEndsElsewhere ] ].
		chain do: [ :process |
			| itsPriority |
			(memory readSlot: self processMyListSlot of: process ifUnreadable: [ unreadable ])
			= list ifFalse: [ problems add: process -> #notInTheQueueItClaims ].
			itsPriority := memory readSlot: self processPrioritySlot of: process ifUnreadable: [ unreadable ].
			(itsPriority ~~ unreadable and: [ itsPriority isIntegerOop ])
				ifFalse: [ problems add: process -> #priorityIsNotANumber ]
				ifTrue: [
					itsPriority asInteger = priority ifFalse: [ problems add: process -> #priorityDoesNotMatchItsQueue ] ] ] ].

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

	^ problems
