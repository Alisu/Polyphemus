helpers
uncheckedReaderOf: aPid

	"The host's reader of that process, unasked whether it is a Pharo VM or may be read: for what
	needs neither (is it there, is it quiet). Of the reader of /proc, where these tests run (setUp)."

	^ PolyphemusMadeFor current processMemoryClass unchecked: aPid
