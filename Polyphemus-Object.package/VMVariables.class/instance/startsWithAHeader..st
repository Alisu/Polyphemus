private
startsWithAHeader: aMapping

	"Whether a library's header begins there: ELF, 64-bit Mach-O, or PE (MZ)."

	| magic |
	magic := [ memory bytesAt: aMapping start count: 4 ] on: Error do: [ :e | nil ].
	magic ifNil: [ ^ false ].
	^ (#( #[ 16r7F 16r45 16r4C 16r46 ] #[ 16rCF 16rFA 16rED 16rFE ] ) includes: magic asByteArray)
		  or: [ (magic first: 2) asByteArray = #[ 16r4D 16r5A ] ]
