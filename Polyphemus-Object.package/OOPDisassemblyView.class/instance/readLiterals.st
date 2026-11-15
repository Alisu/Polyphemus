initialization
readLiterals

	"Its literals as ours, read now and once; one that does not read stands as its
	OOPUnreadableSlot. A block among them reads its own when it is asked one."

	literals := code allReifiedSlots allButFirst collect: [ :each | self hostLiteral: each ]
