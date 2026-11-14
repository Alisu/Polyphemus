tests
testAVMThatDoesNotSayWhereItsCodeIsNamesNoCodeAddressAndLinksNoSendWrong

	"Without where its methods begin no code address has a name, the Cogit is made without where
	a method's code starts, and what a send is linked to is said as an address or not at all."

	| layout frames |
	layout := memory vmLayout.
	frames := (memory activationsOfProcess: process) select: [ :each | each isStackFrame ].

	self assert: (layout nameOfCodeAddress: frames first callerSavedIP) isNil.
	self assert: (layout cogit instVarNamed: #cmEntryOffset) isNil.
	frames do: [ :each |
		(layout linkOfSendAt: each callerSavedIP) ifNotNil: [ :link | self deny: (link beginsWith: 'linked to') ] ]
