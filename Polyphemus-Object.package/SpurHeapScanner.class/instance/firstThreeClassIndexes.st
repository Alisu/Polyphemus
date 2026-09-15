finding a heap
firstThreeClassIndexes

	"nil, false and true are the first three objects of old space, in that order, and their
	classes are the first three entries of the class table. In Pharo 10 that makes them 3075,
	3077 and 3079 -- read out of an image rather than remembered.

	Whether those numbers hold for another version is not assumed anywhere: a candidate is
	only believed if the walk from it runs."

	^ #( 3075 3077 3079 )
