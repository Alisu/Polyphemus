tests
testOpeningAnImageAnswersAHandleAndWhatItHolds

	| result |
	result := PolyphemusMCPServerResource current opening at: 'result'.
	self deny: (result at: 'isError' ifAbsent: [ false ]).
	self assert: (((result at: 'structuredContent') at: 'objects') > 800000).
	self assert: ((self textOf: result) includesSubstring: PolyphemusMCPServerResource current handle)
