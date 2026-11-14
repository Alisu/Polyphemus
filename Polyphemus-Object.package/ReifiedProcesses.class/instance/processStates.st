scheduler
processStates

	"Each process -> #active, #runnable, #waiting, #suspended or #unknown. A process whose list
	does not read, or is no object, is #unknown rather than left out or said to wait."

	| states active lists nilObject unreadable |
	states := Dictionary new.
	active := self reifiedActiveProcess.
	lists := [ self reifiedProcessLists asArray ] on: Error do: [ :e | #(  ) ].
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
								         (lists includes: myList)
									         ifTrue: [ #runnable ]
									         ifFalse: [ #waiting ] ] ] ].
		states at: process put: state ].
	^ states
