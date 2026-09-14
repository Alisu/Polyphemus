scheduler
processStates

	"Where every process of the image stands, as a dictionary of process to one of
	#active, #runnable, #waiting or #suspended.

	A process queued in the scheduler is runnable. One whose myList is some other
	queue is waiting on it, a semaphore or a mutex. One with no list at all is
	suspended, unless it is the process that was running when the image was written."

	| states active lists nilObject |
	states := Dictionary new.
	active := self reifiedActiveProcess.
	lists := self reifiedProcessLists asArray.
	nilObject := self reifiedNilObject.
	self allReifiedProcesses do: [ :process |
		| myList state |
		myList := process reifiedSlotAt: self processMyListSlot.
		state := process = active
			         ifTrue: [ #active ]
			         ifFalse: [
				         myList = nilObject
					         ifTrue: [ #suspended ]
					         ifFalse: [
						         (lists includes: myList)
							         ifTrue: [ #runnable ]
							         ifFalse: [ #waiting ] ] ].
		states at: process put: state ].
	^ states
