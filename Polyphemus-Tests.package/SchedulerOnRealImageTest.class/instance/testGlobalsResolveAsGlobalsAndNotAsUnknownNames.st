tests
testGlobalsResolveAsGlobalsAndNotAsUnknownNames

	"Resolving a name is not enough: the source pane asks the variable what kind it is, and
	one that answers 'not a global' is painted red, the colour for a name that resolves to
	nothing. The binding was right and the screen said otherwise, which is worse than
	either being right or being empty.

	So a global of the image being read comes back as this image's GlobalVariable -- and
	its value is that image's class, never ours, however alike the two are."

	| frame var |
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.
	var := frame lookupVar: 'Semaphore'.

	self assert: var isGlobalVariable.
	self assert: var value name equals: 'Semaphore'.
	self deny: var value == Semaphore
