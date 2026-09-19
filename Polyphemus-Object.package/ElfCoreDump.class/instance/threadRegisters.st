accessing
threadRegisters

	"The registers of each thread, from the NT_PRSTATUS notes: name -> value, in the order
	of x86-64's user_regs_struct, which starts 112 bytes into the note. Empty for another
	machine."

	| names threads |
	(ElfNote unsignedFrom: (self bytesAtOffset: 0 count: 20) at: 19 size: 2) = 62 ifFalse: [
		^ #(  ) ].
	names := #( #r15 #r14 #r13 #r12 #rbp #rbx #r11 #r10 #r9 #r8 #rax #rcx #rdx #rsi #rdi
	            #orig_rax #rip #cs #eflags #rsp #ss ).
	threads := OrderedCollection new.
	(segments select: [ :each | each kind = 4 ]) do: [ :notes |
		ElfNote
			in: (self bytesAtOffset: notes fileOffset count: notes sizeInFile)
			do: [ :type :name :description |
				type = 1 ifTrue: [
					threads add: (Dictionary newFrom: (names withIndexCollect: [ :each :index |
							  each -> (ElfNote
								   unsignedFrom: description
								   at: 112 + (index - 1 * 8) + 1
								   size: 8) ])) ] ] ].
	^ threads
