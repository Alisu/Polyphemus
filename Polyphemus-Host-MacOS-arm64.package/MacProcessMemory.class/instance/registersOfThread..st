reading registers
registersOfThread: aThreadPort

	"ARM_THREAD_STATE64 (flavor 6, 68 words): x0-x28, then fp at 232, lr, sp, pc, cpsr at 264."

	| state count registers |
	state := self class pinned: 272.
	count := self class pinned: 4.
	count unsignedLongAt: 1 put: 68.
	(self class thread: aThreadPort state: 6 into: state count: count) = 0 ifFalse: [ ^ nil ].
	registers := Dictionary new.
	0 to: 28 do: [ :i | registers at: ('x' , i printString) asSymbol put: (state unsignedLongLongAt: i * 8 + 1) ].
	registers
		at: #fp put: (state unsignedLongLongAt: 233);
		at: #lr put: (state unsignedLongLongAt: 241);
		at: #sp put: (state unsignedLongLongAt: 249);
		at: #pc put: (state unsignedLongLongAt: 257);
		at: #pstate put: (state unsignedLongAt: 265).
	^ registers
