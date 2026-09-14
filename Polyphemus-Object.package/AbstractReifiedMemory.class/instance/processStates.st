scheduler
processStates

	"Where every process of the image stands, as a dictionary of process to one of
	#active, #runnable, #waiting, #suspended or #unknown.

	A process queued in the scheduler is runnable. One whose myList is some other
	queue is waiting on it, a semaphore or a mutex. One with no list at all is
	suspended, unless it is the process that was running when the image was written.
	One whose list cannot be read at all is unknown: a damaged process still belongs
	in the answer, because leaving it out would quietly shorten the list of processes
	in the image."

	| states active lists nilObject unreadable |
	states := Dictionary new.
	active := self reifiedActiveProcess.
	lists := [ self reifiedProcessLists asArray ] on: Error do: [ :e | #(  ) ].
	nilObject := self reifiedNilObject.
	unreadable := Object new.
	self allReifiedProcesses do: [ :process |
		| myList state |
		myList := self
			          readSlot: self processMyListSlot
			          of: process
			          ifUnreadable: [ unreadable ].
		state := process = active
			         ifTrue: [ #active ]
			         ifFalse: [
				         myList == unreadable
					         ifTrue: [ #unknown ]
					         ifFalse: [
						         myList = nilObject
							         ifTrue: [ #suspended ]
							         ifFalse: [
								         (lists includes: myList)
									         ifTrue: [ #runnable ]
									         ifFalse: [ #waiting ] ] ] ].
		states at: process put: state ].
	^ states
