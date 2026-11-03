reading headers
slotsAt: anAddress

	"How many slots the object here has, or nil when that cannot be answered."

	^ (self headerAt: anAddress) ifNotNil: [ :header | self slotsAt: anAddress header: header ]
