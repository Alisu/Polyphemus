semaphore index
isOfThisVersionIn: aDirectory

	"Whether the watcher of aDirectory runs this Polyphemus's watcher code."

	| file |
	file := aDirectory / 'watcher-version'.
	^ file exists and: [ file contents trimBoth = self watcherVersion printString ]
