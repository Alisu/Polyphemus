telling
markTitleOf: aDebugger

	"Puts this session's marks in front of that debugger's title, when they are not there."

	aDebugger withWindowDo: [ :window |
		| marked |
		marked := self titleMarked: window title.
		marked = window title ifFalse: [ window title: marked ] ]
