tests
testAMethodThatCarriesNoSourceSaysSoItself

	"#118: asked for its source, a method that carries none went to a decompiler it does not
	have, an error each caller had to catch. It answers nil itself."

	| context |
	context := (reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess) first.

	self assert: (reifiedMemory stacks homeMethodOf: context compiledCode) sourceCode isNil
