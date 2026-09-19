as a compilation scope
binding

	"The binding of this class, as the last literal of methods compiled from its source: a class
	name is a global like any other, wrapped as our compiler expects."

	^ GlobalVariable key: self name asSymbol value: self
