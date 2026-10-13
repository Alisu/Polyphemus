reading the map
mappedFiles

	"Each region a file is mapped into, with the file and where in it (proc_regionfilename)."

	| found path |
	found := OrderedCollection new.
	path := self class pinned: 1024.
	self regionsDo: [ :from :bytes :protection :offset :depth |
		| length |
		length := self class fileOf: pid at: from into: path size: 1024.
		length > 0 ifTrue: [
			found add: (ElfMappedFile
					 start: from
					 stop: from + bytes
					 fileOffset: offset
					 path: (path copyFrom: 1 to: length) asString) ] ].
	^ found asArray
