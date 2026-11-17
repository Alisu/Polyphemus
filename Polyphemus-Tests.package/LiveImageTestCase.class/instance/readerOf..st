helpers
readerOf: aPid

	"The host's reader of that process, which refuses one that is no Pharo VM or may not be read."

	^ PolyphemusMadeFor current processMemoryClass on: aPid
