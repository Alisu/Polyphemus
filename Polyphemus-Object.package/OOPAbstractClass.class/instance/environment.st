as a compilation scope
environment

	"Where this image keeps its own classes.

	This is NOT where names in the snapshot's source are resolved -- those go through
	#lookupVar:declare:, which reads the image the source came from, and answering our
	globals there would bind a name to a class of ours that merely shares a name. This
	answers the machinery's question instead: which CompiledMethod class to instantiate,
	which compiler to run. Those are objects of this image because the compiling happens
	here.

	The bytecode check is what keeps the two apart honestly: if names started resolving
	here, code compiled from the other image's source would stop matching the code in that
	image, and it does not."

	^ self class environment
