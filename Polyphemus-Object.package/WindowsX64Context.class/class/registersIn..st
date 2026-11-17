reading
registersIn: someBytes

	"Name -> value, named as ElfCoreDump names them, from a CONTEXT's bytes or the memory of one."

	| registers |
	registers := Dictionary new.
	self integerRegisterNames doWithIndex: [ :each :index |
		registers at: each put: (someBytes unsignedLongLongAt: 16r78 + (index - 1 * 8) + 1) ].
	registers at: #eflags put: (someBytes unsignedLongAt: 16r44 + 1).
	^ registers
