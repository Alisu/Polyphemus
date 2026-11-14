tests
testTheBrowserSaysOfAProcessThatItsStackIsNotAllThere

	"The process browser labels a process with its frames; one whose stack is cut says so after
	them, and a whole one reads as before."

	| browser cut whole |
	browser := SnapshotProcessBrowser on: reifiedMemory.
	cut := DamagedPharoImageResource process: 'MorphicRenderLoop>>doOneCycleWhile:' in: reifiedMemory.
	whole := DamagedPharoImageResource process: 'Process>>resume' in: reifiedMemory.

	self assert: ((browser labelForProcess: cut) includesSubstring: '(1 frames, then: ').
	self assert: ((browser labelForProcess: cut) includesSubstring: 'is no address of this memory').
	self assert: ((browser labelForProcess: whole) endsWith: '(19 frames)')
