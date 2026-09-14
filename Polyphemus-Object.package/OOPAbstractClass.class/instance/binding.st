as a compilation scope
binding

	"The last literal of a compiled method is the binding of the class that owns it. Code
	generated from a snapshot's source is owned by the class in the snapshot, so that is
	what the binding names, wrapped the way this image's compiler expects."

	^ LiteralVariable key: self name asSymbol value: self
