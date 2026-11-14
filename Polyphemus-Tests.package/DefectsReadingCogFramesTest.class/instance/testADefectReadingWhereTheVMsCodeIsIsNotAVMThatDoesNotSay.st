tests
testADefectReadingWhereTheVMsCodeIsIsNotAVMThatDoesNotSay

	"#118: the Cogit is given where the VM's methods start their code when the VM says, and a
	send's target is compared with where its methods begin; a bug of our own asking was taken
	for a VM that does not say."

	| layout linked raw variables |
	self should: [ (self layoutWhoseVariablesFailIn: #at:) cogit ] raise: ZeroDivide.

	layout := memory vmLayout.
	linked := ((memory activationsOfProcess: process) select: [ :each | each isStackFrame ])
		          collect: [ :each | each callerSavedIP ]
		          thenSelect: [ :each | ((layout linkOfSendAt: each) ifNil: [ '' ]) beginsWith: 'linked to' ].
	linked ifEmpty: [ ^ self skip: 'no frame of this stack returns to a linked send' ].
	raw := layout raw.
	variables := (DefectiveReadDouble of: raw vmVariables) when: #at: answer: [ :name |
		             name = 'methodZoneBase'
			             ifTrue: [ 1 / 0 ]
			             ifFalse: [ raw vmVariables at: name ] ].
	self
		should: [
			(OOPCogLayout on: memory raw: ((DefectiveReadDouble of: raw) when: #vmVariables answer: [ variables ]))
				linkOfSendAt: linked first ]
		raise: ZeroDivide
