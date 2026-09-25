accessing
forgetOtherCachesThan: aDirectory

	"Only one written image is worth keeping, sixty megabytes each."

	self cacheDirectory exists ifFalse: [ ^ self ].
	self cacheDirectory directories do: [ :each |
		each = aDirectory ifFalse: [ each ensureDeleteAll ] ]
