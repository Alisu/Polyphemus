tests
testAFrameDisassemblesTheCodeItRuns

	"#192: a frame was asked for a slot, as a context is, and every frame said its bytecodes
	were unreadable."

	| frame lines |
	frame := (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames first.
	lines := (reifiedMemory stacks disassemblyOfContext: frame) lines.

	self assert: lines size > 10.
	self deny: (lines first beginsWith: 'bytecodes unreadable').
	self assert: (lines anySatisfy: [ :each | each includesSubstring: 'send' ])
