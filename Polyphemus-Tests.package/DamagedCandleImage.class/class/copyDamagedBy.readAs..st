building
copyDamagedBy: someWords readAs: aCleanReading

	"A copy of the clean file with each address -> word of someWords written at the offset of
	that address in the file, the offsets checked on six objects first."

	| header delta offsetOf copy stream |
	header := BlankedContextImageResource headerOf: self cleanFile.
	delta := aCleanReading reifiedSpecialObjectArray address - (header at: #specialObjectsOop).
	offsetOf := [ :address | (header at: #headerSize) + address - delta - (header at: #oldBaseAddress) ].
	BlankedContextImageResource verifyMapping: offsetOf of: aCleanReading in: self cleanFile.
	copy := FileLocator temp asFileReference / ('polyphemus-damaged-candle-' , UUID new asString , '.image').
	self cleanFile copyTo: copy.
	stream := (File named: copy fullName) writeStream.
	[
	someWords do: [ :each |
		stream position: (offsetOf value: each key).
		stream nextPutAll: (each value asByteArrayOfSize: 8) reversed ] ] ensure: [
		stream
			flush;
			close ].
	^ copy
