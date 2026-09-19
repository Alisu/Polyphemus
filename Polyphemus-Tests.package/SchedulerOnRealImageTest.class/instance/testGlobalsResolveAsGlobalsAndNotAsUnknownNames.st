tests
testGlobalsResolveAsGlobalsAndNotAsUnknownNames

	"Globals come back as GlobalVariables whose value is the analysed image's class."

	| frame var |
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.
	var := frame lookupVar: 'Semaphore'.

	self assert: var isGlobalVariable.
	self assert: var value name equals: 'Semaphore'.
	self deny: var value == Semaphore
