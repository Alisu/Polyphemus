private
rebaseOn: aMemory keeping: anObjectsArray

	"As any reading; and the dumped memory it listed by is another's from now on: told anew (#211)."

	super rebaseOn: aMemory keeping: anObjectsArray.
	whole := nil.
	lastObjectAccess := 0
