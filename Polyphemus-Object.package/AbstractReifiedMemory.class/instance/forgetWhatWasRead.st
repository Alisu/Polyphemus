updating
forgetWhatWasRead

	"Drop everything worked out from the object graph (instances by class, globals by name, their
	wrappers): all wrong once the graph is read again."

	instancesByClassTag := nil.
	globalsByName := nil.
	wrappedVariables := nil
