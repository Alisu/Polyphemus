walking
looksLikeAHeapFrom: anAddress upTo: aLimit

	"Whether a walk from here finds at least 500 live objects. Free chunks do not count."

	^ (self walkFrom: anAddress upTo: aLimit) objectCount >= 500
