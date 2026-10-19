walking
looksLikeAHeapFrom: anAddress upTo: aLimit

	"Whether a walk from here finds at least 500 live objects. Free chunks do not count. The walk
	stops at the five hundredth: walked to the end, it read every heap twice."

	^ (self walkFrom: anAddress upTo: aLimit atMost: 500) objectCount >= 500
