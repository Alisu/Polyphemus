tests
testAnArgumentOfAnotherTypeIsRefusedNamingItBeforeTheToolRuns

	"#180: a pid given as text, a handle given as a number, failed deep in the tool with an error of
	Pharo's, which the server answers as a defect of its own. Refused as the tool's, naming the
	argument and what it has to be; an argument given as null is one not given."

	| result |
	result := self resultOf: 'open_process' with: (Dictionary new at: 'pid' put: '1234'; yourself).
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'pid has to be a whole number, not ''1234''').
	result := self resultOf: 'let_go' with: (Dictionary new at: 'handle' put: 12; yourself).
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'handle has to be text, not 12').
	result := self resultOf: 'let_go' with: (Dictionary new at: 'handle' put: nil; yourself).
	self assert: (result at: 'isError').
	self assert: (((result at: 'content') first at: 'text') includesSubstring: 'needs the handle')
