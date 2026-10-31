building the memory
bytes

	"The whole mapping as one ByteArray, any gap between its pieces as zeros: a copy to break
	on purpose. Walking reads the pieces themselves. Refused when it would be mostly gap: pieces
	far apart, a segment the system mapped far away beyond a bridge (#133)."

	| buffer |
	(self pieces size = 1 and: [
		 self pieces first baseAddress = mappingStart and: [
			 self pieces first size = (mappingLimit - mappingStart) ] ]) ifTrue: [ ^ self pieces first bytes ].
	mappingLimit - mappingStart > (2 * self heldByteCount) ifTrue: [
		^ (SpurCannotRead new level: #heap reason: #piecesTooFarApartForOneCopy)
			  detail: mappingStart printStringHex , ' to ' , mappingLimit printStringHex , ', '
				  , self heldByteCount printString , ' bytes held';
			  signal ].
	buffer := ByteArray new: mappingLimit - mappingStart.
	self pieces do: [ :each |
		buffer
			replaceFrom: each baseAddress - mappingStart + 1
			to: each baseAddress - mappingStart + each size
			with: each bytes
			startingAt: 1 ].
	^ buffer
