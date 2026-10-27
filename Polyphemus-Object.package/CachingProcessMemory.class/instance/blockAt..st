reading
blockAt: aStart

	"The 64 KB at aStart, or nil when they are not all readable: read once while held, afresh
	while it runs."

	held == true ifFalse: [ ^ self read: 65536 at: aStart ].
	blocks ifNil: [ blocks := Dictionary new ].
	^ blocks at: aStart ifAbsentPut: [ self read: 65536 at: aStart ]
