exception selector
handles: anException

	"Asked by a handler, as an exception class is."

	^ (anException isKindOf: KeyNotFound) or: [ anException isKindOf: PrimitiveFailed ]
