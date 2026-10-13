dumping
writeDumpTo: aFileReference

	"Its own regions as an ELF core, as LinuxProcessMemory writes one; not the shared libraries."

	^ self writeDumpTo: aFileReference regions: self dumpableSegments
