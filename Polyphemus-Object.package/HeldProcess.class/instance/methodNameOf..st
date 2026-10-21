private
methodNameOf: aReifiedMethod

	"How the image names that method: its class, then its selector."

	^ aReifiedMethod oopMethodClass oopName , ' >> #' , aReifiedMethod oopSelector asString
