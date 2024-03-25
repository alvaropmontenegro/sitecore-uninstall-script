### UNINSTALL SITECORE XP VERSIONS 9.3, 10.x ###
### Script created by Álvaro Montenegro - 2024 ###


###  VARIABLES  ####
$websiteName = "<website-name>"
$websiteRootPath = "C:\inetpub\wwwroot\<instance-name>"
$hostsFilePath = "C:\Windows\System32\drivers\etc\hosts"

$removeSolr = $false;
$solrServiceName = "Solr-8.8.2"
$solrPath = "C:\Solr\Solr-8.8.2"

$serverName = "<server-name>"
$serverUserName = "<username>"
$serverPassword = "<password>"

#Databases - Has different ones? Just add/remove it from the list below
$databaseNames = @("Core", "EXM.Master", "ExperienceForms", "MarketingAutomation", "Master", "Messaging", "Preview", "Processing.Pools", "Processing.Tasks", "ProcessingEngineStorage", "ProcessingEngineTasks", "ReferenceData", "Reporting", "Web", "Xdb.Collection.Shard0", "Xdb.Collection.Shard1", "Xdb.Collection.ShardMapManager")


#############################################################

[System.Environment]::NewLine
Write-Host "Starting the Sitecore Uninstall..."
[System.Environment]::NewLine

$scServer = $websiteName + "sc.dev.local"
$identifyServer = $websiteName + "identityserver.dev.local"
$xConnectServer = $websiteName + "xconnect.dev.local"


# Step 1: Remove the IIS configuration
if(Test-Path IIS:\Sites\$scServer) {
    Remove-Website -Name $scServer
}
if(Test-Path IIS:\Sites\$identifyServer) {
    Remove-Website -Name $identifyServer
}
if(Test-Path IIS:\Sites\$xConnectServer) {
    Remove-Website -Name $xConnectServer
}

Write-Host "1. Sites completely removed."

if(Test-Path IIS:\AppPools\$scServer) {
    Remove-WebAppPool -Name $scServer
}
if(Test-Path IIS:\AppPools\$identifyServer) {
    Remove-WebAppPool -Name $identifyServer
}
if(Test-Path IIS:\AppPools\$xConnectServer) {
    Remove-WebAppPool -Name $xConnectServer
}

Write-Host "2. AppPools completely removed."

# Step 2: Delete entries in the hosts file
$filecontent = Get-Content -Path $hostsFilePath
$changedfilecontent = $filecontent -replace "\d.*$($scServer)*", ""
$changedfilecontent = $changedfilecontent -replace "\d.*$($identifyServer)*", ""
$changedfilecontent = $changedfilecontent -replace "\d.*$($xConnectServer)*", ""
$changedfilecontent | Out-File $hostsFilePath

Write-Host "3. Entry Hosts completely removed."

# Step 3: Delete associated Windows services
$services = @("-MarketingAutomationService", "-ProcessingEngineService", "-IndexWorker") 
$services | ForEach-Object {
    $service = Get-Service -Name $xConnectServer$_ -ErrorAction SilentlyContinue
    if ($service.Length -gt 0) {
        Stop-Service -Name $xConnectServer$_ -Force
        sc.exe delete $xConnectServer$_
    }
}

Write-Host "4. Windows Services completely removed."

# Step 4: Delete the databases from the Sitecore solution
foreach ($databaseName in $databaseNames) {

    $database = $websiteName+"_"+$databaseName
    $query = "Drop database [$database]"

    if(($db = Get-SqlDatabase -ServerInstance $serverName -Name $database -ErrorAction SilentlyContinue)) {
        Write-Host "- Removing: $database"
        invoke-sqlcmd -ServerInstance $serverName -U $serverUserName -P $serverPassword -Query $query
    }
}

Write-Host "5. Databases completely removed."

# Step 5: Delete the file directory
if(Test-Path IIS:\Sites\$websiteRootPath) {
    Remove-Item -Path $websiteRootPath -Recurse -Force
}

Write-Host "6. Root folder completely removed."

# Step 6: Delete/Remove Solr service
if($removeSolr) {
    Stop-Service -Name $solrServiceName -Force
    sc.exe delete $solrServiceName
    Remove-Item -Path $solrPath -Recurse -Force

    Write-Host "7. Solr completely removed."
}

[System.Environment]::NewLine
Write-Host "Sitecore instance uninstallation completed successfully!"

