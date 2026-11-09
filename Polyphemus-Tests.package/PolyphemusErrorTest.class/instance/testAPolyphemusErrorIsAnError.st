tests
testAPolyphemusErrorIsAnError

	"#118: what catches Error today still catches every error of ours."

	self assert: ((Smalltalk globals at: #PolyphemusError) inheritsFrom: Error)
