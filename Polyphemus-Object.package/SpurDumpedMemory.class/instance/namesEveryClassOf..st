reading
namesEveryClassOf: aDumpedMemory

	"Whether each index that one's class table gave a class gives the same class here. An index it
	left empty may be taken now: a class enters the table at its first instance, as an image runs.
	An entry changed is a class moved by a collection, or made anew (#163)."

	| mine theirs empty |
	mine := self classTableContents.
	theirs := aDumpedMemory classTableContents.
	mine size >= theirs size ifFalse: [ ^ false ].
	empty := aDumpedMemory raw heapStart.
	theirs doWithIndex: [ :page :index |
		| now |
		now := mine at: index.
		(page isNil or: [ now isNil ]) ifTrue: [ ^ false ].
		page = now ifFalse: [
			1 to: page size - 7 by: 8 do: [ :at |
				| was |
				was := page unsignedLongLongAt: at.
				(was = empty or: [ was = (now unsignedLongLongAt: at) ]) ifFalse: [ ^ false ] ] ] ].
	^ true
