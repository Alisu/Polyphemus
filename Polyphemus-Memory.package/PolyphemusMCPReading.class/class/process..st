instance creation
process: aPid

	"A running image read at a quiet moment: that moment, the image having run on since."

	^ self new setProcess: aPid reified: (Polyphemus readProcess: aPid)
