accessing
mappedFiles

	"The modules the process had loaded, from the ModuleList stream: each one's path and where
	its image lay, as an ELF core's NT_FILE note names them. Empty without that stream."

	| at count entries |
	at := (self streamOfType: 4 in: (self bytesAtOffset: 0 count: 32)) ifNil: [ ^ #(  ) ].
	count := self unsignedFrom: (self bytesAtOffset: at count: 4) at: 1 size: 4.
	entries := self bytesAtOffset: at + 4 count: 108 * count.
	^ (0 to: count - 1) collect: [ :index |
		  | entry base nameAt length |
		  entry := index * 108 + 1.
		  base := self unsignedFrom: entries at: entry size: 8.
		  nameAt := self unsignedFrom: entries at: entry + 20 size: 4.
		  length := self unsignedFrom: (self bytesAtOffset: nameAt count: 4) at: 1 size: 4.
		  ElfMappedFile
			  start: base
			  stop: base + (self unsignedFrom: entries at: entry + 8 size: 4)
			  fileOffset: 0
			  path: ((ZnCharacterEncoder newForEncoding: 'utf-16le') decodeBytes: (self bytesAtOffset: nameAt + 4 count: length)) ]
