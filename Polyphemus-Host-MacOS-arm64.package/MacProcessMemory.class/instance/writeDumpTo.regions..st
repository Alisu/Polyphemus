dumping
writeDumpTo: aFileReference regions: someSegments

	^ (ElfCoreWriter on: self) write: someSegments to: aFileReference
