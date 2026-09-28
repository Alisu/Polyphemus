dumping
writeDumpTo: aFileReference

	"Write what we can read of this process as an ELF core that ElfCoreDump reads, with the
	files it maps (NT_FILE) but no registers."

	^ self writeDumpTo: aFileReference regions: self segments
