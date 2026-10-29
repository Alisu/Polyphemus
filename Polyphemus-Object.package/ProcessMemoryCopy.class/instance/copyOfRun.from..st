initialization
copyOfRun: someSegments from: aReader

	"Touching segments as one piece, each copied in turn, up to where the reader stopped handing
	bytes over; nil when it handed none."

	| start limit buffer end |
	start := someSegments first address.
	limit := someSegments last address + someSegments last sizeInMemory.
	buffer := ByteArray new: limit - start.
	end := start.
	someSegments do: [ :each |
		end = each address ifTrue: [
			end := self copyFrom: each address upTo: each address + each sizeInMemory of: aReader into: buffer at: start ] ].
	end = start ifTrue: [ ^ nil ].
	^ ByteArrayAddressSpace on: (end < limit ifTrue: [ buffer copyFrom: 1 to: end - start ] ifFalse: [ buffer ]) at: start
