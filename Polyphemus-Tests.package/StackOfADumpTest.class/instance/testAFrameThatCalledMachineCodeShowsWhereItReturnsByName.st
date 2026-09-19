tests
testAFrameThatCalledMachineCodeShowsWhereItReturnsByName

	"An interpreted frame that called machine code will return through
	ceReturnToInterpreterTrampoline, and keeps its own ip in the frame: it still has a pc,
	and its saved ip reads as the trampoline's name."

	| returning |
	returning := self allFrames select: [ :each |
		             each savedIP notNil and: [
			             (memory vmLayout nameOfCodeAddress: each savedIP)
			             = 'ceReturnToInterpreterTrampoline' ] ].

	self assert: returning notEmpty.
	returning do: [ :each |
		self assert: each pc notNil.
		self
			assert: (each inspectionItems detect: [ :item | item key = #savedIP ]) value
			equals: 'ceReturnToInterpreterTrampoline' ]
