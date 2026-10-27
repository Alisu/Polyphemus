dumping
writeDumpTo: aFileReference

	"What we can read of this process as an ELF core that ElfCoreDump reads, with the files it maps
	(NT_FILE), and its threads' registers where the host gives them."

	^ self writeDumpTo: aFileReference regions: self dumpableSegments
