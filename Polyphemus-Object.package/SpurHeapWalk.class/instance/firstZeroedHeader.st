accessing
firstZeroedHeader

	"Where the walk first stepped on a header of zero, which no object and no free chunk has:
	memory wiped or never written; nil when it met none (#211)."

	^ firstZeroedHeader
