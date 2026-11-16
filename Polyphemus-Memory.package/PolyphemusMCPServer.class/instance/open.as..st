tools
open: aReading as: aKindOfHandle

	"Keep a reading under a handle of its own, image1 or core2, and answer the handle."

	| handle |
	opened := (opened ifNil: [ 0 ]) + 1.
	handle := aKindOfHandle , opened printString.
	aReading handle: handle.
	self images at: handle put: aReading.
	^ handle
