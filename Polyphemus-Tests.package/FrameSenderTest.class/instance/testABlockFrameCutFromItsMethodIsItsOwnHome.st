tests
testABlockFrameCutFromItsMethodIsItsOwnHome

	"#149 for a frame, as for a context: where the stack is cut before the method a block is of,
	the block's activation is its own home. Pharo's debugger asks it, and nil there was an error
	of ours in its panes."

	| frame |
	frame := BlockFrameCutFromItsMethod new.
	self assert: frame home identicalTo: frame
