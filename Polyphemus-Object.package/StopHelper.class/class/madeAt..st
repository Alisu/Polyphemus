accessing
madeAt: aDirectory

	"aDirectory made, though observers started at once make it side by side (#72)."

	^ PolyphemusEdition ensureDirectory: aDirectory
