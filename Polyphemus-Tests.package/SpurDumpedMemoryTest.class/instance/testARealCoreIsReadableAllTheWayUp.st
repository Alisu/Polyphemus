tests
testARealCoreIsReadableAllTheWayUp

	"The other half of the ladder. It is easy to write checks that refuse things; the claim
	worth testing is that a dump of a VM which was running perfectly well passes every one
	of them -- including the audit of every entry of every class table page in use."

	self assert: dumped classTableProblems asArray equals: #(  ).
	self assert: dumped readability refusals asArray equals: #(  ).
	self assert: dumped readability isFullyReadable.
	self assert: dumped readability highestReadableLevel equals: #specialObjects
