tools
sessionOnDeepestProcessIn: aReifiedMemory

	"A post mortem session on the deepest stack (deepestProcessIn:)."

	^ self sessionOn: (self deepestProcessIn: aReifiedMemory) in: aReifiedMemory
