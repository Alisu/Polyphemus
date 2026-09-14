tests
testInterpretedStateIsRebuiltAfterResourceReset

	"SUnit resets resources between suite runs. The fixture must come back
	interpreted rather than freshly loaded, otherwise every test that depends on the
	interpreted state silently sees a one frame stack."

	| resourceClass interp fp depth |
	resourceClass := self class currentImage.
	resourceClass reset.
	resourceClass availableFor: self.

	interp := resourceClass current interpreter.
	fp := interp framePointer.
	depth := 0.
	[ fp isNil or: [ fp = 0 ] ] whileFalse: [
		depth := depth + 1.
		fp := interp frameCallerFP: fp ].

	self assert: depth equals: self class numberOfSteps
