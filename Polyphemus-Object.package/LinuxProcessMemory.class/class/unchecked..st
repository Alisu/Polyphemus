instance creation
unchecked: aPid

	"Without asking whether it is a Pharo virtual machine or whether we may read it. For
	looking at something that is not one, and for the checks themselves."

	^ self new setPid: aPid; yourself
