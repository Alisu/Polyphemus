reading
readingWith: aBlock

	"A reading of a copy of the Candle image damaged as aBlock says: given the clean reading, it
	answers the words to overwrite, each as address -> word. The copy is read, then deleted."

	| clean copy |
	clean := self readingOf: self cleanFile.
	copy := self copyDamagedBy: (aBlock value: clean) readAs: clean.
	^ [ self readingOf: copy ] ensure: [ copy ensureDelete ]
