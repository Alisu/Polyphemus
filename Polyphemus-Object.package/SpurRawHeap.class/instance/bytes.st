building the memory
bytes

	"The whole mapping as one ByteArray, any gap between its pieces as zeros: a copy to break
	on purpose. Walking reads the pieces themselves."

	| buffer |
	(self pieces size = 1 and: [
		 self pieces first baseAddress = mappingStart and: [
			 self pieces first size = (mappingLimit - mappingStart) ] ]) ifTrue: [ ^ self pieces first bytes ].
	buffer := ByteArray new: mappingLimit - mappingStart.
	self pieces do: [ :each |
		buffer
			replaceFrom: each baseAddress - mappingStart + 1
			to: each baseAddress - mappingStart + each size
			with: each bytes
			startingAt: 1 ].
	^ buffer
