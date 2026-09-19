tests
testTheRunningProcessStackReadsAsMethodNames

	"The image was written from inside SessionManager>>launchSnapshot:andQuit:. The two frames
	above it are blocks, named after their home method: a block has no selector of its own."

	| lines |
	lines := reifiedMemory stackDescriptionOfProcess: reifiedMemory reifiedActiveProcess.

	self assert: lines size equals: 3.
	self assert: lines first equals: 'SessionManager>>launchSnapshot:andQuit:'.
	self assert: (lines allSatisfy: [ :each | each includesSubstring: '>>' ]).
	self assert: (lines allButFirst allSatisfy: [ :each | each endsWith: '[block]' ])
