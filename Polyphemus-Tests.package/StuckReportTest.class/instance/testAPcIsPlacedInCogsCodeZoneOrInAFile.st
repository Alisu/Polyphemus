tests
testAPcIsPlacedInCogsCodeZoneOrInAFile

	"The code zone as VM 9 kept it (codeBase to limitAddress, 2026-10-05), a library, and
	memory that is neither."

	| zone files |
	zone := 16r1670A000 -> 16r16868000.
	files := { (ElfMappedFile start: 16r7000 stop: 16r9000 fileOffset: 0 path: '/usr/lib/libc.so.6') }.

	self assert: (StuckThread locationOf: 16r167380DA codeZone: zone files: files) equals: 'machine code, in Cog''s code zone'.
	self assert: (StuckThread locationOf: 16r8000 codeZone: zone files: files) equals: 'libc.so.6'.
	self assert: (StuckThread locationOf: 16r20000000 codeZone: zone files: files) equals: 'anonymous memory'.
	self assert: (StuckThread locationOf: 16r8000 codeZone: nil files: files) equals: 'libc.so.6'
