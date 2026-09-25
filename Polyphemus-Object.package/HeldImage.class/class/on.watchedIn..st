instance creation
on: aPid watchedIn: aDirectory

	^ self new setReader: (LinuxProcessMemory on: aPid) directory: aDirectory asFileReference
