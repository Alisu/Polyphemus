dumping
writeDumpTo: aFileReference regions: someSegments

	"Not yet on Windows: a minidump of it, written by Windows' own tools, is read (#32)."

	^ self error: 'a core of a Windows process is not written yet: read a minidump of it instead (#32)'
