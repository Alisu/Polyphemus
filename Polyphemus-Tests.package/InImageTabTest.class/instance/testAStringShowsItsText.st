tests
testAStringShowsItsText

	| string |
	string := self anInstanceOf: 'ByteString' suchThat: [ :each | each size between: 3 and: 40 ].
	self assert: string inImageText equals: string asString.
	self assert: string inImageDescription equals: string asString printString
