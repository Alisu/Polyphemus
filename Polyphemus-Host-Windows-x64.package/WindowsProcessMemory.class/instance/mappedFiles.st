reading the map
mappedFiles

	"Each module the process loaded, its path and where its image lies, as a minidump's
	ModuleList names them (K32EnumProcessModulesEx, every kind; MODULEINFO: base, then size)."

	| modules needed count info name |
	modules := self class pinned: 8 * 1024.
	needed := self class pinned: 4.
	(self class modules: self handle into: modules size: 8 * 1024 needed: needed filter: 3) = 0 ifTrue: [ ^ #(  ) ].
	count := (needed unsignedLongAt: 1) // 8 min: 1024.
	info := self class pinned: 24.
	name := self class pinned: 2048.
	^ ((1 to: count) collect: [ :index |
		   | module length |
		   module := modules unsignedLongLongAt: index - 1 * 8 + 1.
		   length := self class fileName: self handle module: module into: name size: 1024.
		   (self class information: self handle module: module into: info size: 24) = 0
			   ifTrue: [ nil ]
			   ifFalse: [
				   ElfMappedFile
					   start: (info unsignedLongLongAt: 1)
					   stop: (info unsignedLongLongAt: 1) + (info unsignedLongAt: 9)
					   fileOffset: 0
					   path: ((ZnCharacterEncoder newForEncoding: 'utf-16le') decodeBytes: (name copyFrom: 1 to: length * 2)) ] ])
		  reject: [ :each | each isNil ]
