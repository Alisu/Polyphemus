tests
testAnAddressIsReadFromTheRegionThatHeldIt

	"Finding the byte for an address is the same arithmetic as finding an object in an image
	file: the offset of the region, plus how far into it the address is. There is just more
	than one region."

	| dump |
	dump := ElfCoreDump on: dumpFile.

	self assert: (dump byteAt: 16r400000) equals: 16rAA.
	self assert: (dump byteAt: 16r7F0000000) equals: 16rBB.
	self assert: (dump byteAt: 16r7F00001FF) equals: 16rBB.
	self assert: (dump byteAt: 16r7F0000200) equals: 16rCC
