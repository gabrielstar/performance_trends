$script:testDir = "$PSScriptRoot\test_data\json"
$script:OUT_FILE = "jmeter.csv"

Describe 'Selenium Performance Data' {
	BeforeAll {
		Copy-Item "$testDir\*.json" -Destination "$TestDrive"
		Remove-Item -Path $PSScriptRoot\test_data\json\*.csv
		. $PSScriptRoot\parse-tests-results.ps1 -dryRun $true
		ConvertJSONstoJmeterCSV -resultsPath $TestDrive
	}
	Context 'When I parse allure JSON results' {
		It 'should create a jmeter.csv file ' {
			"$TestDrive\$script:OUT_FILE" | Should -Exist
		}
		It 'should jmeter.csv be correct file ' {
			$expected = Get-Content -Path "$TestDrive\$script:OUT_FILE"
			$expected | Should -Be @('timeStamp,elapsed,label,responseCode,responseMessage,threadName,dataType,success,failureMessage,bytes,sentBytes,grpThreads,allThreads,URL,Latency,IdleTime,Connect', '1601901494174,12405,[SCENARIO] Check Objectivity about us page second time,200,OK,,text,true,,,,,,,,,', '1601901494179,5813,[STEP] Given  User is on objectivity page,200,OK,,text,true,,,,,,,,,', '1601901499993,5702,[STEP] When  User goes to about us page,200,OK,,text,true,,,,,,,,,', '1601901505696,877,[STEP] Then  User should be on "About Us | Objectivity" page,200,OK,,text,true,,,,,,,,,', '1601901494174,12405,[SCENARIO] Check Objectivity about us page second time,200,OK,,text,true,,,,,,,,,', '1601901494179,5813,[STEP] Given  User is on objectivity page,200,OK,,text,true,,,,,,,,,', '1601901499993,5702,[STEP] When  User goes to about us page,200,OK,,text,true,,,,,,,,,', '1601901505696,877,[STEP] Then  User should be on "About Us | Objectivity" page,200,OK,,text,true,,,,,,,,,')
		}
	}
}