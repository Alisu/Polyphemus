reading
namesEveryClassOf: aDumpedMemory

	"Whether each index that one's class table gave a class of old space gives the same class here.
	An index left empty may be taken now (a class enters the table at its first instance), and a
	class still in new space moves at a scavenge and is not taken over (#189). Else: moved, or made anew."

	| mine theirs oldSpace |
	mine := self classTableContents.
	theirs := aDumpedMemory classTableContents.
	mine size >= theirs size ifFalse: [ ^ false ].
	oldSpace := aDumpedMemory raw heapStart.
	theirs doWithIndex: [ :page :index |
		| now |
		now := mine at: index.
		(page isNil or: [ now isNil ]) ifTrue: [ ^ false ].
		page = now ifFalse: [
			1 to: page size - 7 by: 8 do: [ :at |
				| was |
				was := page unsignedLongLongAt: at.
				(was <= oldSpace or: [ was = (now unsignedLongLongAt: at) ]) ifFalse: [ ^ false ] ] ] ].
	^ true
