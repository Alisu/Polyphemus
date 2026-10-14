reading
symbols

	"Variables and functions by name (storage class external or static, in a section), each as
	its offset from the image base: its section's address plus its value."

	| header count table strings sections |
	symbols ifNotNil: [ ^ symbols ].
	symbols := Dictionary new.
	header := (self unsignedIn: self bytes at: 16r3C size: 4) + 4.
	table := self unsignedIn: self bytes at: header + 8 size: 4.
	count := self unsignedIn: self bytes at: header + 12 size: 4.
	strings := table + (18 * count).
	sections := self sectionAddressesAfter: header.
	(self symbolEntriesIn: table count: count) do: [ :entry |
		| section class |
		section := self unsignedIn: self bytes at: entry + 12 size: 2.
		class := self unsignedIn: self bytes at: entry + 16 size: 1.
		((section between: 1 and: sections size) and: [ class = 2 or: [ class = 3 ] ]) ifTrue: [
			symbols
				at: (self nameOfSymbolAt: entry strings: strings)
				put: (sections at: section) + (self unsignedIn: self bytes at: entry + 8 size: 4) ] ].
	^ symbols
