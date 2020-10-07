$script:testDir = "$PSScriptRoot\test_data\k6"
$script:OUT_FILE = "k6_jmeter.csv"
$script:TEST_FILE = "k6.csv"

Describe 'Selenium Performance Data' {
	BeforeAll {
		Copy-Item "$testDir\$script:TEST_FILE" -Destination "$TestDrive"
		. $PSScriptRoot\parse-tests-results.ps1 -dryRun $true
		ConvertJSONstoJmeterCSV -resultsPath $TestDrive -resultsFile "$script:TEST_FILE" -outputFile "$script:OUT_FILE"
	}
	Context 'When I parse allure JSON results' {
		It 'should create a jmeter file ' {
			"$TestDrive\$script:OUT_FILE" | Should -Exist
		}
		It 'should jmeter file be correct file ' {
			$expected = Get-Content -Path "$TestDrive\$script:OUT_FILE"
			$expected -contains `
 				@( '1602060604,2,/url,200,success,threadName,dataType,true,failureMessage,bytes,sentBytes,grpThreads,allThreads,http://localhost:3000/url,Latency,IdleTime,Connect') `
 				| Should -Be $true

		}
	}
}