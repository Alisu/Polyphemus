context protocol
outerContext

	"The activation the block it runs was made in, through its closure; nil for a method
	activation, a block made with no outer context, or one that cannot be read (#184)."

	^ memory stacks outerActivationOf: self closureOrNil