walking
looksLikeAHeapFrom: anAddress upTo: aLimit

	"Whether a run from here is long enough to be a heap rather than an accident.

	Two megabytes of noise, walked three thousand times from random places, never managed more
	than two objects once implausible class indices were refused, and never more than
	seventy-eight without that check. Real memory is not noise -- it holds text, zeros and
	pointers, which walk further by accident -- so the number to beat is hundreds, not tens."

	^ (self walkFrom: anAddress upTo: aLimit) objectCount >= 500
