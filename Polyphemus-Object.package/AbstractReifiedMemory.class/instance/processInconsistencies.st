scheduler
processInconsistencies

	"Everything about the process graph that a working VM could not have written,
	as a collection of associations from the offending object to what is wrong.

	Stage one has to survive a damaged image, so nothing here trusts the graph: a
	queue may loop, a process may disagree with the queue holding it, a process may
	point at something that is not a context, and a slot may hold something that is
	not an object at all. Every one of those is a line in the report and none of them
	is a raise -- the report is the answer, and it has to cover the whole image, not
	stop at the first word that is wrong."

	| problems lists nilObject active unreadable myList |
	problems := OrderedCollection new.
	nilObject := self reifiedNilObject.
	active := self reifiedActiveProcess.
	unreadable := Object new.
	lists := [ self reifiedProcessLists asArray ]
		         on: Error
		         do: [ :e |
			         problems add: active -> #schedulerQueuesAreUnreadable.
			         #(  ) ].

	"the running process is taken out of its queue while it runs"
	myList := self
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
			(self readSlot: self listLastLinkSlot of: list ifUnreadable: [ unreadable ])
			= chain last ifFalse: [ problems add: list -> #queueEndsElsewhere ] ].
		chain do: [ :process |
			(self readSlot: self processMyListSlot of: process ifUnreadable: [ unreadable ])
			= list ifFalse: [ problems add: process -> #notInTheQueueItClaims ].
			[
			(self readSlot: self processPrioritySlot of: process ifUnreadable: [ unreadable ])
				asInteger = priority ifFalse: [
				problems add: process -> #priorityDoesNotMatchItsQueue ] ]
				on: Error
				do: [ :e | problems add: process -> #priorityIsNotANumber ] ] ].

	self allReifiedProcesses do: [ :process |
		| context |
		context := self
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
