tests
testAStackWordWithItsTopBitSetIsReadUnsigned

	"#118: frames read stack words unsigned, whichever way the VMMaker of this edition reads them."

	| pages address before word |
	pages := reifiedMemory interpreter stackPages.
	address := (pages pages detect: [ :each | each isFree ]) baseAddress - 8.
	word := 16rFFFFFFFFFFFFFFF9.
	before := pages unsignedLongAt: address.
	[
	pages unsignedLongAt: address put: word.
	self assert: (reifiedMemory vmLayout wordAt: address) equals: word ] ensure: [
		pages unsignedLongAt: address put: before ]