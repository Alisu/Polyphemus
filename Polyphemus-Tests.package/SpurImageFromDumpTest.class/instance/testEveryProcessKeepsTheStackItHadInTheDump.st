tests
testEveryProcessKeepsTheStackItHadInTheDump

	"The dump's frames became contexts, so every process of the image is one of the dump's
	with the stack it had there. The dump holds more of them: a heap walk finds the ones a
	collection frees, which it froze mid-flight."

	| inTheImage inTheDump |
	inTheImage := self class stacksOf: (Polyphemus readImageFile: self written).
	inTheDump := self class stacksOfTheDump.

	self assert: inTheImage size < inTheDump size.
	inTheImage do: [ :each |
		self
			assert: (inTheDump includes: each)
			description: each printString , ' is no stack of the dump' ].
	self assert: (inTheImage anySatisfy: [ :each | each value > 5 ])
