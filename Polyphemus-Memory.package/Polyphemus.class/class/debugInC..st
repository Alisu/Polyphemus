tools
debugInC: aPid

	"The real Pharo debugger on the process its VM ran when it entered C, its title saying which
	call (#18); refused, saying where the VM is, when it is not in a C call."

	| memory report session |
	memory := self readProcess: aPid.
	report := self whereIsStuck: aPid reading: memory.
	report mainThread isInACCall ifFalse: [ ^ self error: 'not in a C call: ' , report mainThread summary ].
	session := self sessionOn: memory reifiedActiveProcess in: memory.
	session mark: report mainThread titleMark.
	^ StDebugger openOn: session withFullView: true
