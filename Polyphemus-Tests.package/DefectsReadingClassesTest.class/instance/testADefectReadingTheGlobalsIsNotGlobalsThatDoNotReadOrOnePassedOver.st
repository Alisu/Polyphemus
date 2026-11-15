tests
testADefectReadingTheGlobalsIsNotGlobalsThatDoNotReadOrOnePassedOver

	"#118: globals that do not read are refused as such, and one whose name does not read is
	passed over. A bug of our own reading either is neither. Each defect is planted where the
	object is kept, and taken out; what the reading had worked out is forgotten before and after."

	| memory |
	memory := self memory.
	{ (memory reifiedSmalltalk reifiedSlotAt: 1). (memory globalNamed: #Transcript) } do: [ :each |
		memory objectAt: each address put: (self defective: each in: #reifiedSlotAt:).
		memory forgetWhatWasRead.
		[ self should: [ memory globalsByName ] raise: ZeroDivide ] ensure: [
			memory objectAt: each address put: each.
			memory forgetWhatWasRead ] ]
