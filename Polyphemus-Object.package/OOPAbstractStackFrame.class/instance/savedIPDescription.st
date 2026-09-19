inspection
savedIPDescription

	"The saved ip, or the name of the VM routine it points at."

	^ savedIP ifNotNil: [ (self layout nameOfCodeAddress: savedIP) ifNil: [ savedIP ] ]
