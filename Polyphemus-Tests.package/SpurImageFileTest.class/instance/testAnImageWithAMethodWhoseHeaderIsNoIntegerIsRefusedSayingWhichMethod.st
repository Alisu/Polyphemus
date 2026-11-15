tests
testAnImageWithAMethodWhoseHeaderIsNoIntegerIsRefusedSayingWhichMethod
	<readsAnUnsoundHeap>

	"#207: a copy of candle with the header of one method pointing at the method. The simulator
	asserts while loading such a file; the ladder refuses it first, with the method's address in
	the file. The clean file, and a copy damaged elsewhere in a method, still read."

	| clean method inTheFile copy file |
	clean := DamagedCandleImage readingOf: DamagedCandleImage cleanFile.
	method := (clean oopClassNamed: 'PCCompiledMethod') instancesOop first.
	copy := DamagedCandleImage
		        copyDamagedBy: { ((DamagedCandleImage slot: 1 of: method) -> [ :distance | inTheFile := method address - distance ]) }
		        readAs: clean.
	[
	file := SpurImageFile on: copy.
	[ self deny: ((SpurRawHeap on: file) expectingIntegerMethodHeaders readability canRead: #objects) ] ensure: [ file close ].
	self
		should: [ Polyphemus readImageFile: copy fullName ]
		raise: SpurCannotRead
		withExceptionDo: [ :refusal |
			self assert: refusal level equals: #objects.
			self assert: refusal reason equals: #aMethodsHeaderIsNoInteger.
			self assert: (refusal messageText endsWith: '(the method at ' , (inTheFile printStringRadix: 16) , ' in the file)') ] ]
		ensure: [ copy ensureDelete ].
	self assert: (Polyphemus readabilityOfImageFile: DamagedCandleImage cleanFile fullName) isFullyReadable
