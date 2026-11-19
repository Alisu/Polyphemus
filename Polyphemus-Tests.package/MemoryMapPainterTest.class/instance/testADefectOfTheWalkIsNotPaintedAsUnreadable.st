tests
testADefectOfTheWalkIsNotPaintedAsUnreadable

	"#212: any error under the walk was painted as a place that does not read, a defect of ours
	among them. A refusal is still painted so; a defect is shown."

	| scanner painter |
	scanner := (DefectiveReadDouble of: (SpurHeapScanner on: (ByteArrayAddressSpace on: (self heapBytesFor: #( #( 40 1 1 ) )) at: self baseAddress)))
		           when: #headerAt: answer: [ :address | 1 / 0 ];
		           yourself.
	painter := MemoryMapPainter
		           on: scanner
		           geometry: (MemoryMapGeometry from: self baseAddress to: self baseAddress + 64 bytesPerPixel: 8 width: 4).
	self should: [ painter paintFrom: self baseAddress upTo: self baseAddress + 64 ] raise: ZeroDivide.
	scanner when: #headerAt: answer: [ :address | (SpurCannotRead new level: #bytes reason: #notCopiedWhileHeld) signal ].
	painter paintFrom: self baseAddress upTo: self baseAddress + 64.
	self assert: (self categoriesOf: painter upTo: 0) equals: #( #unreadable )
