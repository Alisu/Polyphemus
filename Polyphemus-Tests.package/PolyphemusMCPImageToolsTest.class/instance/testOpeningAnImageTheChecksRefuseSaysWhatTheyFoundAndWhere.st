tests
testOpeningAnImageTheChecksRefuseSaysWhatTheyFoundAndWhere
	<readsAnUnsoundHeap>

	"#118: open_image loaded a file without the checks readImageFile: makes. A copy of candle with
	a method's header zeroed is refused as the facade refuses it: by the check, with the method's
	address in the file, not by whatever the simulator then stops on."

	| clean method copy result |
	clean := DamagedCandleImage readingOf: DamagedCandleImage cleanFile.
	clean do: [ :each | (method isNil and: [ (each isKindOf: OOPAbstractObject) and: [ each oopFormat = 26 ] ]) ifTrue: [ method := each ] ].
	copy := DamagedCandleImage copyDamagedBy: { (method address + 8 -> 0) } readAs: clean.
	result := [ self callOn: PolyphemusMCPServer new tool: 'open_image' with: (Dictionary new at: 'path' put: copy fullName; yourself) ]
		          ensure: [ [ copy ensureDelete ] on: FileException do: [ :stillOpen | nil ] ].
	self assert: (result at: 'isError').
	self assert: ((self textOf: result) includesSubstring: 'aMethodsHeaderIsNoInteger (the method at 16r')
