instance creation
refuseItsOwn: aPid

	"A reader stops its target to read it: the observer stopping itself would never wake (#117)."

	aPid = self ownPid ifTrue: [ ^ (CannotReadProcess new pid: aPid reason: #itIsThisVeryImage) signal ]
