accessing
allOopSlotNames

	"The names of its instances' slots are in the class, which does not read: refused by name (#193)."

	^ NotInTheReading signal: self name , ' does not read: the slots of its instances have no names here'
