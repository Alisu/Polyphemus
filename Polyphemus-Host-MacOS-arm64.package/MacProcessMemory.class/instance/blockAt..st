reading
blockAt: aStart

	"The 64 KB at aStart, or nil when they are not all readable; read once."

	blocks ifNil: [ blocks := Dictionary new ].
	^ blocks at: aStart ifAbsentPut: [ self read: 65536 at: aStart ]
