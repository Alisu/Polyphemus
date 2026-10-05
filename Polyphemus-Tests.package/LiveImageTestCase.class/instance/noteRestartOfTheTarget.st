restarting
noteRestartOfTheTarget

	"Said in the run's report (bin/run-tests.sh passes NOTE lines on), never silently (#31)."

	('    NOTE ' , self class name , '>>' , testSelector , ' started its target again: VM 9 could not map its heap (#31)') traceCr
