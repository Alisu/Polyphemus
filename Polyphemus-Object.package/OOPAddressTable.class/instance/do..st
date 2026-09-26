enumerating
do: aBlock

	"Every slot, empty ones included, in address order."

	slots do: [ :array | array do: aBlock ]
