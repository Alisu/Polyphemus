tests
testACountOfStackPagesNoVMHasIsRefused

	"#211: numStackPages is read from the VM's own memory and sized a loop over its page records.
	Damaged, it is refused as the VM's, not followed for as many pages as it says."

	self
		should: [ VMVariablesSayingTooManyPages new stackPages ]
		raise: SpurCannotRead
		withExceptionDo: [ :refusal | self assert: refusal reason equals: #itSaysMoreStackPagesThanAVMHas ]
