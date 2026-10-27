dumping
writeDumpTo: aFileReference regions: someSegments

	"The same, of a chosen few regions: a test need not write half a gigabyte to prove the format."

	^ (ElfCoreWriter on: self) write: someSegments to: aFileReference
