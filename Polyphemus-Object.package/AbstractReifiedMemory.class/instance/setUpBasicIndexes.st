initialization
setUpBasicIndexes
	"initialize many addresses to classes that we need to work
	Still nothing should be reified after this point"
	self setUpMetaclass.
	self setUpMode.
	self setUpStringClasses.
	self setUpCompiledMethodClass.
	self setUpCompiledBlockClass.
	self setUpMetaclassForTraitIndex.
	self setUpTraitedMetaclassIndex.
	self setUpObjectHandlers.