reading
copyProcess: aPid

	"What a reading needs of a running VM, copied while it is held still at a safe moment, quiet or
	else outside a collection (#66, #113), to be read as a core is once it has run on, or ended."

	^ PolyphemusMadeFor current processMemoryClass copyOf: aPid