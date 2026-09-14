tests
testTheRunningProcessStackReadsAsMethodNames

	"A stack is only useful once it reads as methods. The image was written from
	inside SessionManager>>launchSnapshot:andQuit:, and the two frames above it are
	blocks, whose selector has to come from their home method: a compiled block
	carries no selector of its own."

	| lines |
	lines := reifiedMemory stackDescriptionOfProcess: reifiedMemory reifiedActiveProcess.

	self assert: lines size equals: 3.
	self assert: lines first equals: 'SessionManager>>launchSnapshot:andQuit:'.
	self assert: (lines allSatisfy: [ :each | each includesSubstring: '>>' ]).
	self assert: (lines allButFirst allSatisfy: [ :each | each endsWith: '[block]' ])
