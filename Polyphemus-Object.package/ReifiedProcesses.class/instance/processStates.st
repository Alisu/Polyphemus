scheduler
processStates

	"Each process -> #active, #runnable, #waiting, #suspended or #unknown. A process whose list
	does not read, or is no object, is #unknown rather than left out or said to wait; so is one
	on a list when the scheduler's lists do not read. None where the processes cannot be listed."

	| states active lists nilObject unreadable |
	states := Dictionary new.
	self whyItsProcessesDoNotRead ifNotNil: [ ^ states ].
	active := self reifiedActiveProcess.
	lists := [ self reifiedProcessLists asArray ] on: PolyphemusError do: [ :refusal | nil ].
	nilObject := memory reifiedNilObject.
	unreadable := Object new.
	self allReifiedProcesses do: [ :process |
		| myList state |
		myList := memory
			          readSlot: self processMyListSlot
			          of: process
			          ifUnreadable: [ unreadable ].
		state := process = active
			         ifTrue: [ #active ]
			         ifFalse: [
				         (myList == unreadable or: [ myList isImmediateOop ])
					         ifTrue: [ #unknown ]
					         ifFalse: [
						         myList = nilObject
							         ifTrue: [ #suspended ]
							         ifFalse: [
								         lists ifNil: [ #unknown ] ifNotNil: [
									         (lists includes: myList)
										         ifTrue: [ #runnable ]
										         ifFalse: [ #waiting ] ] ] ] ].
		states at: process put: state ].
	^ states
