reading the map
regionsDo: aBlock

	"Each region, recursing into submaps: start, size, protection, file offset, and the depth it
	was found at (mach_vm_region_recurse). None at all: the process ended (#79), refused so."

	| address size depth info count found |
	address := self class pinned: 8.
	size := self class pinned: 8.
	depth := self class pinned: 4.
	info := self class pinned: 76.
	count := self class pinned: 4.
	found := 0.
	[
	count unsignedLongAt: 1 put: 19.
	(self class regionOf: task address: address size: size depth: depth info: info count: count) = 0 ] whileTrue: [
		(info unsignedLongAt: 49) = 0
			ifTrue: [
				| from bytes |
				from := address unsignedLongLongAt: 1.
				bytes := size unsignedLongLongAt: 1.
				found := found + 1.
				"Five arguments: value:value:value:value:value:'s primitive fails on this VM, as on Pharo 14's."
				aBlock valueWithArguments: {
						from.
						bytes.
						(info unsignedLongAt: 1).
						(info unsignedLongLongAt: 13).
						(depth unsignedLongAt: 1) }.
				address unsignedLongLongAt: 1 put: from + bytes ]
			ifFalse: [ depth unsignedLongAt: 1 put: (depth unsignedLongAt: 1) + 1 ] ].
	(found = 0 and: [ self exists not ]) ifTrue: [
		^ (CannotReadProcess new pid: pid reason: #noSuchProcess) signal ]
