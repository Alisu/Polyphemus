instance creation
covering: someRanges

	"Ranges as start -> end, end excluded, in any order."

	^ self new setRanges: someRanges asArray objects: Dictionary new
