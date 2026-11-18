tests
testATemporaryIsReadOnceForItsRow

	"#191: a row says what a temporary holds and where; it was read once for each, and a read by
	name follows temp vectors and outer activations."

	| reads row |
	reads := 0.
	row := PolyphemusMCPServer new rowOfTemporary: 'own' readBy: [
		       reads := reads + 1.
		       self frame receiver ].
	self assert: reads equals: 1.
	self assert: (row at: 'name') equals: 'own'.
	self assert: (row at: 'address') notNil
