updating
forgetWhatWasRead

	"Drop everything worked out from the object graph: which objects are instances of which
	class, the globals indexed by name, and the variable objects wrapping them. All are
	answers about a graph that is about to be read again, so all are wrong from here on.

	Kept in one place, and called from the one method that rebuilds the reified view, so
	that the next thing derived from the heap has an obvious place to be forgotten."

	instancesByClassTag := nil.
	globalsByName := nil.
	wrappedVariables := nil
