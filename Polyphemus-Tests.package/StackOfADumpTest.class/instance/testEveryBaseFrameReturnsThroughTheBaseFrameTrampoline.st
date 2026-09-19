tests
testEveryBaseFrameReturnsThroughTheBaseFrameTrampoline

	"CoInterpreter>>makeBaseFrameFor: gives a base frame ceBaseFrameReturnPC as the ip to
	return to: the layout read from the frames and the VM's own variables agree."

	| bases |
	bases := self allFrames select: [ :each | each isBaseFrame ].

	self assert: bases notEmpty.
	bases do: [ :each |
		self
			assert: (memory vmLayout nameOfCodeAddress: each callerSavedIP)
			equals: 'ceBaseFrameReturnTrampoline' ]
