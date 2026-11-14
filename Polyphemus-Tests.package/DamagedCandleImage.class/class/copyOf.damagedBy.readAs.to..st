building
copyOf: aCleanFile damagedBy: someWords readAs: aCleanReading to: aTarget

	"A copy of aCleanFile at aTarget with each address -> word of someWords, or -> bytes, or -> a
	block giving the word from the distance between the reading's addresses and the file's,
	written at the offset of that address in the file, the offsets checked on six objects first."

	| header delta offsetOf stream |
	header := BlankedContextImageResource headerOf: aCleanFile.
	delta := aCleanReading reifiedSpecialObjectArray address - (header at: #specialObjectsOop).
	offsetOf := [ :address | (header at: #headerSize) + address - delta - (header at: #oldBaseAddress) ].
	BlankedContextImageResource verifyMapping: offsetOf of: aCleanReading in: aCleanFile.
	aCleanFile copyTo: aTarget.
	stream := (File named: aTarget fullName) writeStream.
	[
	someWords do: [ :each |
		| written |
		written := each value isBlock
			           ifTrue: [ each value value: delta ]
			           ifFalse: [ each value ].
		stream position: (offsetOf value: each key).
		stream nextPutAll: (written isInteger
				 ifTrue: [ (written asByteArrayOfSize: 8) reversed ]
				 ifFalse: [ written ]) ] ] ensure: [
		stream
			flush;
			close ].
	^ aTarget
