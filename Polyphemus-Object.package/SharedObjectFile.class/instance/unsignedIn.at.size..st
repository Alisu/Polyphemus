reading
unsignedIn: someBytes at: anOffset size: aCount

	"Little endian, anOffset from 0, as offsets in these files are."

	^ LittleEndian unsignedIn: someBytes from: anOffset + 1 size: aCount
