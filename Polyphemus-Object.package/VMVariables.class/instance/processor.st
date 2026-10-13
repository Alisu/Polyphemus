accessing
processor

	"#x86_64 or #aarch64: the processor the VM ran on, as its memory says; x86-64 when it does not."

	^ (memory respondsTo: #processor)
		  ifTrue: [ memory processor ]
		  ifFalse: [ #x86_64 ]
