tests
testTheCodeOfAMethodIsItsBytecodesAlone

	"Without header, literals or trailer, as the edit and the install compare it (#118: once)."

	| method |
	method := Object >> #yourself.
	self
		assert: (SpurEdit codeOf: method)
		equals: ((method initialPC to: method endPC) collect: [ :each | method at: each ])
