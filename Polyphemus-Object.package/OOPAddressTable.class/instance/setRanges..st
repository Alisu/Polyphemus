initialization
setRanges: someRanges

	starts := (someRanges collect: [ :each | each key ]) asArray.
	slots := (someRanges collect: [ :each | Array new: each value - each key >> 3 ]) asArray
