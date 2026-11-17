reading
machineCodeTextOf: aMethodAddress

	"The CogMethod Cog compiled of the method at that address, as text (#95); nil when its
	header holds no CogMethod."

	^ (CogMethodListing on: self) textOf: aMethodAddress