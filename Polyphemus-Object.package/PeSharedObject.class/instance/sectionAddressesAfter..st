reading
sectionAddressesAfter: aCoffHeader

	"Each section's address, as an offset from the image base, in order: they follow the optional
	header, 40 bytes each, the address 12 bytes in."

	| count first |
	count := self unsignedIn: self bytes at: aCoffHeader + 2 size: 2.
	first := aCoffHeader + 20 + (self unsignedIn: self bytes at: aCoffHeader + 16 size: 2).
	^ (0 to: count - 1) collect: [ :i | self unsignedIn: self bytes at: first + (40 * i) + 12 size: 4 ]
