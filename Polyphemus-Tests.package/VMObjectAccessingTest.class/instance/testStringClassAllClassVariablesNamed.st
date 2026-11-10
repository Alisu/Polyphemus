tests-classVariables
testStringClassAllClassVariablesNamed
	self assert: ((reifiedMemory reifiedStringClass oopClassSide oopClassVariableNamed: #AsciiOrder) oopClassName last: 9) equals: #ByteArray