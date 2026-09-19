tests
testARealCoreIsReadableAllTheWayUp

	"The other half of the ladder. It is easy to write checks that refuse things; the claim
	worth testing is that a dump of a VM which was running perfectly well passes every one
	of them -- including the audit of every entry of every class table page in use."

	self assert: dumped raw classTableProblems asArray equals: #(  ).
	self assert: dumped raw readability refusals asArray equals: #(  ).
	self assert: dumped raw readability isFullyReadable.
	self assert: dumped raw readability highestReadableLevel equals: #specialObjects
