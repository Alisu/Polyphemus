instance creation
core: aPath

	^ self new setKind: 'a core' path: aPath reified: (Polyphemus readCoreDump: aPath)
