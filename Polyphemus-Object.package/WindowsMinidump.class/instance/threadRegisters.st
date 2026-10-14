accessing
threadRegisters

	"Each thread's registers, name -> value, from the ThreadList stream's x64 CONTEXTs, named as
	ElfCoreDump names them. Empty for another processor, or without that stream."

	| at count threads names |
	self processor = #x86_64 ifFalse: [ ^ #(  ) ].
	at := (self streamOfType: 3 in: (self bytesAtOffset: 0 count: 32)) ifNil: [ ^ #(  ) ].
	count := self unsignedFrom: (self bytesAtOffset: at count: 4) at: 1 size: 4.
	threads := self bytesAtOffset: at + 4 count: 48 * count.
	names := #( #rax #rcx #rdx #rbx #rsp #rbp #rsi #rdi #r8 #r9 #r10 #r11 #r12 #r13 #r14 #r15 #rip ).
	^ (0 to: count - 1) collect: [ :index |
		  | context registers |
		  context := self
			             bytesAtOffset: (self unsignedFrom: threads at: index * 48 + 45 size: 4)
			             count: 256.
		  registers := Dictionary new.
		  names doWithIndex: [ :each :i |
			  registers at: each put: (self unsignedFrom: context at: 120 + (i - 1 * 8) + 1 size: 8) ].
		  registers at: #eflags put: (self unsignedFrom: context at: 69 size: 4).
		  registers ]
