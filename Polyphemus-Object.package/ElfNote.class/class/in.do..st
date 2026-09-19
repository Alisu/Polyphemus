reading
in: aByteArray do: aBlock

	"Evaluate aBlock with the type, name and description of each note in aByteArray."

	| index |
	index := 1.
	[ index + 11 <= aByteArray size ] whileTrue: [
		| nameSize descriptionSize type name description |
		nameSize := (ElfNote unsignedFrom: aByteArray at: index size: 4).
		descriptionSize := (ElfNote unsignedFrom: aByteArray at: index + 4 size: 4).
		type := (ElfNote unsignedFrom: aByteArray at: index + 8 size: 4).
		index := index + 12.
		name := (aByteArray copyFrom: index to: index + nameSize - 1) asString
			        copyWithout: Character null.
		index := index + (nameSize + 3 bitAnd: -4).
		description := aByteArray copyFrom: index to: (index + descriptionSize - 1 min: aByteArray size).
		index := index + (descriptionSize + 3 bitAnd: -4).
		aBlock value: type value: name value: description ]
