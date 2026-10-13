instance creation
on: aPid watchedIn: aDirectory

	^ self new setReader: (PolyphemusMadeFor current processMemoryClass on: aPid) directory: aDirectory asFileReference
