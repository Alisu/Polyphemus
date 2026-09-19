tests
testAClassVariableResolvesInTheImageBeingRead

	"Class variables are neither instance variables nor globals, and used to come back unknown
	and land in our Undeclared. The value is that image's object, not ours."

	| frame var |
	frame := self frameDescribed: 'SmalltalkImage>>lowSpaceWatcher'.
	var := frame lookupVar: 'LowSpaceProcess'.

	self assert: var isNotNil.
	self deny: var isUndeclaredVariable.
	self assert: var value oopClassName equals: 'Process'
