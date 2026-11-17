tests
testItRefusesAFileThatIsNotAMinidump

	"By name, each way a file is not one: other bytes, a file too short for a header, and a
	minidump taken without its memory, which has nothing to read."

	| notADump withoutMemory |
	withoutMemory := (self minidumpOf: #(  )) copy.
	self into: withoutMemory at: 33 put: 5 size: 4.
	notADump := PolyphemusEdition current scratch / 'polyphemus-not-a-minidump'.
	{
		(ByteArray new: 128 withAll: 7) -> 'not a Windows minidump'.
		#[ 77 68 77 80 ] -> 'runs past the end of the file'.
		withoutMemory -> 'without its memory' } do: [ :each |
		notADump ensureDelete.
		notADump binaryWriteStreamDo: [ :stream | stream nextPutAll: each key ].
		[
		self
			should: [ WindowsMinidump on: notADump ]
			raise: UnknownFormat
			withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: each value) ] ]
			ensure: [ notADump ensureDelete ] ]
