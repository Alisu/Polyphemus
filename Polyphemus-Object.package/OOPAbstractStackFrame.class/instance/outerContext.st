context protocol
outerContext

	"The activation the block it runs was made in, through its closure; nil for a method
	activation, a block made with no outer context, or a frame we cannot find (#184). Refused by
	name where its closure does not read."

	^ memory stacks outerActivationOf: self closureOrNil
