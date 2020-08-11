function Get-SeElement {
    param(
        #Specifies whether the selction text is to select by name, ID, Xpath etc
        [ValidateSet("CssSelector", "Name", "Id", "ClassName", "LinkText", "PartialLinkText", "TagName", "XPath")]
        [ByTransformAttribute()]
        [string]$By = "XPath",
        [Parameter(Position = 1, Mandatory = $true)]
        [string]$Selection,
        #Specifies a time out
        [Parameter(Position = 2)]
        [Int]$Timeout = 0,
        #The driver or Element where the search should be performed.
        #TODO Alias 
        [Parameter(Position = 3, ValueFromPipeline = $true)]
        [Alias('Element')]
        $Driver = $Script:SeDriversCurrent,

        [parameter(DontShow)]
        [Switch]$Wait

    )
    process {
        ##TODO Maybe the implicit timeout should be used here ?
        if ($wait -and $Timeout -eq 0) { $Timeout = 30 }

        if ($TimeOut -and $Target -is [OpenQA.Selenium.Remote.RemoteWebDriver]) {
            $TargetElement = [OpenQA.Selenium.By]::$By($Selection)
            $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Target, (New-TimeSpan -Seconds $Timeout))
            $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementExists($TargetElement)
            $WebDriverWait.Until($Condition)
        }
        elseif ($Target -is [OpenQA.Selenium.Remote.RemoteWebElement] -or
            $Target -is [OpenQA.Selenium.Remote.RemoteWebDriver]) {
            if ($Timeout) { Write-Warning "Timeout does not apply when searching an Element" }
            $Target.FindElements([OpenQA.Selenium.By]::$By($Selection))
        }
        else { throw "No valid target was provided." }
    }
}