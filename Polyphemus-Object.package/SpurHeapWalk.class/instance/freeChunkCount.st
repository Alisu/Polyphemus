accessing
freeChunkCount

	"Free chunks met on the way. They are objects of a sort -- they have a header and a size,
	and the walk steps over them -- but they hold no live data, so they are counted apart:
	a run through untouched memory is all free chunks and says nothing."

	^ freeChunkCount
