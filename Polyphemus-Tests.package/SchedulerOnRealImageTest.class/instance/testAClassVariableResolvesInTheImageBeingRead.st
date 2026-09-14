tests
testAClassVariableResolvesInTheImageBeingRead

	"A name in a method is not always an instance variable or a global. Class variables are
	neither, and until they were looked up, every one of them -- LowSpaceProcess here, and
	the finalization ones elsewhere -- came back unknown, showed red, and was written into
	this image's Undeclared.

	The value is that image's object: its low space watcher process, not ours."

	| frame var |
	frame := self frameDescribed: 'SmalltalkImage>>lowSpaceWatcher'.
	var := frame lookupVar: 'LowSpaceProcess'.

	self assert: var isNotNil.
	self deny: var isUndeclaredVariable.
	self assert: var value oopClassName equals: 'Process'
