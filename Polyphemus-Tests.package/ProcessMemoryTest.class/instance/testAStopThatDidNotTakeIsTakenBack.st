tests
testAStopThatDidNotTakeIsTakenBack

	"#181: asked to stop and not seen stopped in time, a process may stop a moment later, or be
	suspended already in part: what was sent is taken back, or it stays so with nobody there."

	| reader |
	reader := ProcessMemoryThatWillNotStop new.
	self should: [ reader whileStopped: [ nil ] ] raise: SpurCannotRead.
	self assert: reader tookBack.
	reader := ProcessMemoryThatWillNotStop new.
	self should: [ reader whileStoppedWhenQuiet: [ nil ] tries: 1 ] raise: SpurCannotRead.
	self assert: reader tookBack
