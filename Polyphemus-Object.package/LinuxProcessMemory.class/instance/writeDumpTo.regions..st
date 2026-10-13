dumping
writeDumpTo: aFileReference regions: someSegments

	"The same, of a chosen few regions. A whole image is half a gigabyte, and a test does
	not need half a gigabyte to prove the format is right."

	^ (ElfCoreWriter on: self) write: someSegments to: aFileReference
