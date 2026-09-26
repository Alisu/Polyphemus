instance creation
into: aProcessMemory watchedIn: aDirectory

	^ self new setReader: aProcessMemory directory: aDirectory asFileReference
