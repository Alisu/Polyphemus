dumping
writeDumpTo: aFileReference

	"Write what we can read of this process as an ELF core that ElfCoreDump reads. No
	PT_NOTE, so no registers."

	^ self writeDumpTo: aFileReference regions: self segments
