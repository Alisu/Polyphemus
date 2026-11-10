accessing
whenWritingDo: aBlock

	"aBlock told each address written, in the order written."

	onWrite := aBlock
