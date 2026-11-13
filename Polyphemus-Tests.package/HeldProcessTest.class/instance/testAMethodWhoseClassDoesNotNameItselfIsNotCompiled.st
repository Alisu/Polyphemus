tests
testAMethodWhoseClassDoesNotNameItselfIsNotCompiled

	"#189: a class whose name does not read answers a placeholder, and the image was asked to
	compile into the class of that name. Refused by name, nothing asked of the image."

	| log channel held |
	log := OrderedCollection new.
	channel := ScriptedChannel answering: #( nil nil nil ).
	held := HeldProcess on: channel reader: nil identityHash: 7.
	channel log: log.
	self
		should: [ held fix: UnnamedClassDouble new to: 'tick: n ^ n' restartingAt: 0 ]
		raise: NotInTheReading.
	self assert: log isEmpty
