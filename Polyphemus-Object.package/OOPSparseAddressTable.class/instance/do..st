enumerating
do: aBlock

	"The objects kept, in address order: an empty slot has nothing to say."

	objects keys asSortedCollection do: [ :each | aBlock value: (objects at: each) ]
