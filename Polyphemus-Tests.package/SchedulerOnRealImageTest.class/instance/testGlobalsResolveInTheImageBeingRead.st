tests
testGlobalsResolveInTheImageBeingRead

	"Names must resolve against the globals of the image in the file, not ours. The two
	images share plenty of class names, and binding to ours would answer objects that
	only look right."

	| binding |
	binding := reifiedMemory globalNamed: 'Process'.

	self deny: binding isNil.
	self assert: (binding reifiedSlotAt: 1) asString equals: 'Process'.
	self assert: (binding reifiedSlotAt: 2) oopClassName equals: 'Process class'.
	self assert: (reifiedMemory globalNamed: 'NoSuchGlobalAnywhere') isNil
