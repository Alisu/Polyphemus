accessing
threadRegisters

	"Each thread's registers, name -> value, from the ThreadList stream's x64 CONTEXTs, named as
	ElfCoreDump names them. Empty for another processor, or without that stream."

	| at count threads |
	self processor = #x86_64 ifFalse: [ ^ #(  ) ].
	at := (self streamOfType: 3 in: (self bytesAtOffset: 0 count: 32)) ifNil: [ ^ #(  ) ].
	count := self unsignedFrom: (self bytesAtOffset: at count: 4) at: 1 size: 4.
	threads := self tableAtOffset: at + 4 count: 48 * count.
	^ (0 to: count - 1) collect: [ :index |
		  WindowsX64Context registersIn: (self
				   bytesAtOffset: (self unsignedFrom: threads at: index * 48 + 45 size: 4)
				   count: WindowsX64Context registerBytes) ]
