tests
testAWordOfAFrameThatIsAnImmediateIsReadAsOne

	"#199: a small integer on a frame's stack was answered as nil, being at no address. Every
	frame of the dump, each word of its stack against what the frame answers for it."

	| immediates |
	immediates := 0.
	self allFrames do: [ :each |
		each stackWords with: each operandStack do: [ :word :object |
			(memory isImmediate: word) ifTrue: [
				immediates := immediates + 1.
				self assert: object notNil.
				self assert: object isImmediateOop ] ] ].
	self assert: immediates > 0
