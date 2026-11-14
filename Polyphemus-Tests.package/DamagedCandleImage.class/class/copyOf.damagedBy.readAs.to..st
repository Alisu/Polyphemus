building
copyOf: aCleanFile damagedBy: someWords readAs: aCleanReading to: aTarget

	"A copy of aCleanFile at aTarget with each address -> word of someWords written at the offset
	of that address in the file, the offsets checked on six objects first."

	| header delta offsetOf stream |
	header := BlankedContextImageResource headerOf: aCleanFile.
	delta := aCleanReading reifiedSpecialObjectArray address - (header at: #specialObjectsOop).
	offsetOf := [ :address | (header at: #headerSize) + address - delta - (header at: #oldBaseAddress) ].
	BlankedContextImageResource verifyMapping: offsetOf of: aCleanReading in: aCleanFile.
	aCleanFile copyTo: aTarget.
	stream := (File named: aTarget fullName) writeStream.
	[
	someWords do: [ :each |
		stream position: (offsetOf value: each key).
		stream nextPutAll: (each value asByteArrayOfSize: 8) reversed ] ] ensure: [
		stream
			flush;
			close ].
	^ aTarget
