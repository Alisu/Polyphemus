scheduler
processInconsistencies

	"Everything in the process graph a working VM could not have written, as object ->
	problem. Reports and never raises, so it covers the whole image."

	| problems lists nilObject active unreadable myList |
	problems := OrderedCollection new.
	nilObject := memory reifiedNilObject.
	active := self reifiedActiveProcess.
	unreadable := Object new.
	lists := [ self reifiedProcessLists asArray ]
		         on: Error
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
		([ self listIsCircular: list ] on: Error do: [ :e | false ]) ifTrue: [
			problems add: list -> #queueIsCircular ].
		chain := [ self processesInList: list ]
			         on: Error
			         do: [ :e |
				         problems add: list -> #queueIsUnreadable.
				         #(  ) ].
		chain ifNotEmpty: [
			(memory readSlot: self listLastLinkSlot of: list ifUnreadable: [ unreadable ])
			= chain last ifFalse: [ problems add: list -> #queueEndsElsewhere ] ].
		chain do: [ :process |
			(memory readSlot: self processMyListSlot of: process ifUnreadable: [ unreadable ])
			= list ifFalse: [ problems add: process -> #notInTheQueueItClaims ].
			[
			(memory readSlot: self processPrioritySlot of: process ifUnreadable: [ unreadable ])
				asInteger = priority ifFalse: [
				problems add: process -> #priorityDoesNotMatchItsQueue ] ]
				on: Error
				do: [ :e | problems add: process -> #priorityIsNotANumber ] ] ].

	self allReifiedProcesses do: [ :process |
		| context |
		context := memory
			           readSlot: self processSuspendedContextSlot
			           of: process
			           ifUnreadable: [ unreadable ].
		context == unreadable
			ifTrue: [ problems add: process -> #suspendedContextIsUnreadable ]
			ifFalse: [
				(context = nilObject or: [
					 [ context isContextOop ] on: Error do: [ :e | false ] ]) ifFalse: [
					problems add: process -> #suspendedContextIsNotAContext ] ] ].

	^ problems
