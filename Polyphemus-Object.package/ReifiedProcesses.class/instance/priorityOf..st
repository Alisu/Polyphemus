scheduler
priorityOf: aProcess

	"Its priority as an integer; nil where the slot does not read or holds no integer."

	| unreadable priority |
	unreadable := Object new.
	priority := memory readSlot: self processPrioritySlot of: aProcess ifUnreadable: [ unreadable ].
	^ (priority ~~ unreadable and: [ priority isIntegerOop ]) ifTrue: [ priority asInteger ]
