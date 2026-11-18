accessing
current

	"The one host package loaded. None means the baseline has none for this host; two, that an
	image holds another host's package too, and none is taken for this one's (#118)."

	^ self oneOf: self subclasses
