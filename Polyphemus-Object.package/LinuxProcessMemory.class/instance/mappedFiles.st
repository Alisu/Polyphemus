accessing
mappedFiles

	"The files mapped into the process, from its map: the lines that name a path."

	^ ((self pathFor: 'maps') asFileReference contents lines
		   select: [ :line | (line substrings: ' ') size >= 6 and: [ (line substrings: ' ') last first = $/ ] ])
		  collect: [ :line |
			  | parts range |
			  parts := line substrings: ' '.
			  range := (parts at: 1) substrings: '-'.
			  ElfMappedFile
				  start: (Number readFrom: (range at: 1) base: 16)
				  stop: (Number readFrom: (range at: 2) base: 16)
				  fileOffset: (Number readFrom: (parts at: 3) base: 16)
				  path: (' ' join: (parts allButFirst: 5)) ]
