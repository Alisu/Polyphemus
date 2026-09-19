tests
testATemporaryIsNotReadWhenThisHostCannotReproduceTheFrame

	"#6. Temporaries are only named where the code compiled here is the file's. The method is
	marked not reproducible, so a refusal is required instead of a value."

	| memory frame |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToPharo10.
	frame := (memory allReifiedProcesses
		          inject: OrderedCollection new
		          into: [ :all :each | all addAll: (memory contextsOfProcess: each); yourself ])
		         detect: [ :each |
			         (memory descriptionOfContext: each)
			         = 'SessionManager>>snapshot:andQuit: [block]' ].
	memory
		rememberedAt: 'hostMethod.' , frame homeMethod address printString
		ifAbsentPut: [ false ].

	self assert: (memory faithfulCodeOf: frame) isNil.
	self assert: (memory tempNamesOf: frame) isEmpty.
	self should: [ frame tempNamed: 'wait' ] raise: Error
