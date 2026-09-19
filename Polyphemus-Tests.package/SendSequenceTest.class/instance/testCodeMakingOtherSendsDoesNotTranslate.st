tests
testCodeMakingOtherSendsDoesNotTranslate

	"Inlined, ifTrue: is a jump; not inlined, it is a send. The two do not correspond, so no
	pc is answered rather than the nearest one."

	| inlined sent |
	inlined := self compile: 'foo ^ x ifTrue: [ 1 ]' options: #( + optionInlineIf ).
	sent := self compile: 'foo ^ x ifTrue: [ 1 ]' options: #( - optionInlineIf ).

	self deny: (SendSequence of: inlined) selectors = (SendSequence of: sent) selectors.
	self
		assert: ((SendSequence of: sent) pcIn: (SendSequence of: inlined) for: (SendSequence of: sent) sendPCs first)
		equals: nil
