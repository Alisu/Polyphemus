tests
testAWordOfAFrameThatIsAnImmediateIsReadAsOne

	"#199: no damage, but read as if it were: a receiver or a temporary that is a small integer,
	a character or a small float was answered as nil, being at no address."

	| base word |
	base := self frames last framePointer.
	word := reifiedMemory wordSize.
	{ 16r29. 16r2A. 16r1C } do: [ :each |
		self while: base - (4 * word) holds: each do: [
			| frame |
			frame := self frames last.
			self assert: frame receiver isImmediateOop.
			self deny: ((reifiedMemory descriptionOfContext: frame) beginsWith: 'an unreadable object') ] ].
	self while: base - (4 * word) holds: 16r29 do: [
		self
			assert: (reifiedMemory descriptionOfContext: self frames last)
			equals: 'SmallInteger>>launchSnapshot:andQuit:' ].
	self while: base - (5 * word) holds: 16r29 do: [
		| frame |
		frame := self frames last.
		self assert: (frame tempAt: 3) asInteger equals: 5.
		self assert: frame operandStack first asInteger equals: 5 ]
