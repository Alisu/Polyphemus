tests
testATemporaryIsNotReadWhenThisHostCannotReproduceTheFrame

	"#6. On Pharo 11 a block temporary read as an Array instead of its Semaphore: names and
	slots come from analysing the source here, which is only safe where the code compiled
	here is the file's code. This host can reproduce it, so the test marks the method as
	not reproducible and requires a refusal instead of a value."

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
