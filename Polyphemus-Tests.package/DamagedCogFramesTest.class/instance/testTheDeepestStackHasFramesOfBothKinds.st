tests
testTheDeepestStackHasFramesOfBothKinds

	"What the other tests stand on: a stack of several frames, the oldest of its page among them."

	| frames |
	frames := self frames.
	self assert: frames size >= 5.
	self assert: (frames anySatisfy: [ :each | each isBaseFrame ]).
	self assert: (memory stacks whyTheStackEndsOfProcess: process) isNil
