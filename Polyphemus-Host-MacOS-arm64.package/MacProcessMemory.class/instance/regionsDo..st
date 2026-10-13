reading the map
regionsDo: aBlock

	"Each region, recursing into submaps: start, size, protection, file offset
	(mach_vm_region_recurse; the info is 19 words, protection at 0, offset at 12, is_submap at 48)."

	| address size depth info count |
	address := self class pinned: 8.
	size := self class pinned: 8.
	depth := self class pinned: 4.
	info := self class pinned: 76.
	count := self class pinned: 4.
	[
	count unsignedLongAt: 1 put: 19.
	(self class regionOf: task address: address size: size depth: depth info: info count: count) = 0 ] whileTrue: [
		(info unsignedLongAt: 49) = 0
			ifTrue: [
				| from bytes |
				from := address unsignedLongLongAt: 1.
				bytes := size unsignedLongLongAt: 1.
				aBlock value: from value: bytes value: (info unsignedLongAt: 1) value: (info unsignedLongLongAt: 13).
				address unsignedLongLongAt: 1 put: from + bytes ]
			ifFalse: [ depth unsignedLongAt: 1 put: (depth unsignedLongAt: 1) + 1 ] ]
