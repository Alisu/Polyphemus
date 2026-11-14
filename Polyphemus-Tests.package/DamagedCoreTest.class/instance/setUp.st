running
setUp

	super setUp.
	self class hasAnElfCore ifFalse: [ ^ self skip: 'no ELF core here; make one with bin/take-dump.sh' ].
	memory := self class memory
