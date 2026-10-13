helpers
waitForFile: aName in: aDirectory

	"Whether the file appears within ten seconds."

	^ (1 to: 100) anySatisfy: [ :each |
		  (aDirectory / aName) exists or: [ (Delay forMilliseconds: 100) wait. false ] ]
