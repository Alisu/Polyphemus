accessing
processor

	"#x86_64 or #aarch64, by e_machine (62 or 183); nil for another machine."

	| machine |
	machine := ElfNote unsignedFrom: (self bytesAtOffset: 0 count: 20) at: 19 size: 2.
	machine = 62 ifTrue: [ ^ #x86_64 ].
	machine = 183 ifTrue: [ ^ #aarch64 ].
	^ nil
