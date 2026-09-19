scheduler
processStates

	"Each process -> #active, #runnable, #waiting, #suspended or #unknown. An unreadable
	process is #unknown rather than left out."

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
