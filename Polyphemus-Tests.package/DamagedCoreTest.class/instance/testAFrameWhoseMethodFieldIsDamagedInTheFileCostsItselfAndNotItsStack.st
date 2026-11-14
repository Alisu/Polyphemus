tests
testAFrameWhoseMethodFieldIsDamagedInTheFileCostsItselfAndNotItsStack

	"#198 on a core: the method field of the second frame of the deepest stack is a tagged word
	in the file. The stack keeps its frames and ends at its oldest; that frame refuses its code
	by name and is described as unreadable where it is."

	| process frames |
	process := (self class processDamagedIn: #methodField) ifNil: [ ^ self skip: 'no stack of three frames in this core' ].
	frames := self framesOf: process.

	self assert: frames size >= 3.
	self should: [ (frames at: 2) compiledCode ] raise: PolyphemusError.
	self assert: ((memory descriptionOfContext: (frames at: 2)) endsWith: 'an unreadable selector').
	self deny: ((memory descriptionOfContext: (frames at: 3)) endsWith: 'an unreadable selector').
	self assert: (memory stacks whyTheStackEndsOfProcess: process) isNil
