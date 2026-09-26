accessing
current

	"The edition this code is, unless a test says otherwise (using:during:)."

	^ inUse ifNil: [
		  self host: (PolyphemusHost pharo: 10 os: 'Linux' cpu: 'x64') targets: #( 10 ) ]
