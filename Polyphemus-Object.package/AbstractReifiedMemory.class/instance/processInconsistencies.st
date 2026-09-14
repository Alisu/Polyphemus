scheduler
processInconsistencies

	"Everything about the process graph that a working VM could not have written,
	as a collection of associations from the offending object to what is wrong.

	Stage one has to survive a damaged image, so nothing here trusts the graph: a
	queue may loop, a process may disagree with the queue holding it, and a process
	may point at something that is not a context at all."

	| problems lists nilObject |
	problems := OrderedCollection new.
	nilObject := self reifiedNilObject.
	lists := self reifiedProcessLists asArray.

	lists doWithIndex: [ :list :priority |
		| chain |
		(self listIsCircular: list) ifTrue: [
			problems add: list -> #queueIsCircular ].
		chain := self processesInList: list.
		chain ifNotEmpty: [
			(list reifiedSlotAt: self listLastLinkSlot) = chain last ifFalse: [
				problems add: list -> #queueEndsElsewhere ] ].
		chain do: [ :process |
			(process reifiedSlotAt: self processMyListSlot) = list ifFalse: [
				problems add: process -> #notInTheQueueItClaims ].
			[ (process reifiedSlotAt: self processPrioritySlot) asInteger = priority ifFalse: [
				problems add: process -> #priorityDoesNotMatchItsQueue ] ]
				on: Error
				do: [ :e | problems add: process -> #priorityIsNotANumber ] ] ].

	self allReifiedProcesses do: [ :process |
		| context |
		context := process reifiedSlotAt: self processSuspendedContextSlot.
		(context = nilObject or: [
			 [ context isContextOop ] on: Error do: [ :e | false ] ]) ifFalse: [
			problems add: process -> #suspendedContextIsNotAContext ] ].

	^ problems
