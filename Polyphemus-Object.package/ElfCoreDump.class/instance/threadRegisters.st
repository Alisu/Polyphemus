accessing
threadRegisters

	"Each thread's registers from the NT_PRSTATUS notes, name -> value, laid out from 112 bytes
	in: x86-64's user_regs_struct, or aarch64's user_pt_regs. Empty for another machine."

	| names threads |
	names := self processor = #x86_64
		         ifTrue: [
			         #( #r15 #r14 #r13 #r12 #rbp #rbx #r11 #r10 #r9 #r8 #rax #rcx #rdx #rsi #rdi
			            #orig_rax #rip #cs #eflags #rsp #ss ) ]
		         ifFalse: [
			         self processor = #aarch64 ifFalse: [ ^ #(  ) ].
			         ((0 to: 28) collect: [ :i | ('x' , i printString) asSymbol ]) , #( #fp #lr #sp #pc #pstate ) ].
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
