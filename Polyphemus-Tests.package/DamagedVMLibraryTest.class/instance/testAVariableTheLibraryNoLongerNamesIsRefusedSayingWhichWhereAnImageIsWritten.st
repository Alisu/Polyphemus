tests
testAVariableTheLibraryNoLongerNamesIsRefusedSayingWhichWhereAnImageIsWritten

	"#118, #182: writing an image from a dump reads the VM's variables for the header. One the
	damaged library no longer names is refused saying which, in the reading's own words after."

	| name |
	name := self class namesTakenOut first.
	self
		should: [ SpurImageFromDump new read: name from: memory vmLayout raw vmVariables ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal |
			self assert: (refusal messageText beginsWith: 'the dumped VM''s ' , name , ' does not read: cannot read vm: ') ]
