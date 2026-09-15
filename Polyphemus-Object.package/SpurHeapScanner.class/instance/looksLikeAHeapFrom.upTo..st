walking
looksLikeAHeapFrom: anAddress upTo: aLimit

	"Whether a run from here is long enough to be a heap rather than an accident.

	Counted in live objects only. Free chunks are stepped over but prove nothing: a walk
	through memory nobody has written is free chunks the whole way.

	Two megabytes of noise, walked three thousand times from random places, never managed
	more than two objects once implausible class indices were refused. Real memory is not
	noise, so the number to beat is hundreds."

	^ (self walkFrom: anAddress upTo: aLimit) objectCount >= 500
