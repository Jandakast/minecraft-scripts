[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)][String]$ModFolderPath,                  # Root Folder where all the mod jars are located
    [Parameter(Mandatory = $true)][String]$DataPackFolderPath,             # Root Folder of the DataPack where all the advancement overrides will go
    [Parameter(Mandatory = $true)][String]$AdvancementTemplateFilePath,    # Path to the json file that will be used as a template for the advancement overrides
    [Parameter()][switch]$OverWriteExistingFiles = $false,                 # If set, will overwrite existing files instead of just adding missing ones
    [Parameter()][switch]$CreateLogFile = $false                           # If set, will create a log file with the output of the script
)

# Load the .NET assembly for working with zip files and suppress the output
[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null

$AdvancementTemplate = (Get-Content -Path $AdvancementTemplateFilePath -Raw | ConvertFrom-Json) | ConvertTo-Json
$JarFileList = (Get-ChildItem -Path $ModFolderPath -Filter *.jar).FullName
$AdvancementJsonFilesToOverride = @()
$CountOfFilesUpdated = 0

# Create a log file if the switch is set
if ($CreateLogFile)
{
    $LogFile = Join-Path -Path $PSScriptRoot -ChildPath "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))-files.log"
    New-Item -Path $LogFile -ItemType File -Force | Out-Null
}

# Loop through all the jar files and find all the advancement files that are not in recipes or loot_tables directories
foreach($sourceFile in $JarFileList)
{
    $zip = [IO.Compression.ZipFile]::OpenRead($sourceFile)
    $entries = $zip.Entries.FullName
    $zip.Dispose()
    $AdvancementJsonFilesToOverride += $entries | Where-Object { ($_ -like "data/*") -and ($_ -like "*advancements*") -and ($_ -like "*.json") -and ($_ -notlike "*/recipes/*") -and ($_ -notlike "*/loot_tables/*") }
}

# Print to the console the number of advancement files found in the jar files
Write-Output "Found $($AdvancementJsonFilesToOverride.Count) advancement files"

# Loop through all the identified advancement files and generate the diabled tempalte in the appropriate DataPack folder location
foreach ($AdvancementFile in $AdvancementJsonFilesToOverride)
{
    $OutFilePath = Join-Path -Path $DataPackFolderPath -ChildPath $AdvancementFile

    if (-not (Test-Path -Path $OutFilePath) -or $OverWriteExistingFiles)
    {
        New-Item -Path $OutFilePath -ItemType File -Force | Out-Null
        $AdvancementTemplate | Set-Content -Path $OutFilePath -Force
        $CountOfFilesUpdated++
        if ($CreateLogFile) 
        {
            Add-Content -Path $LogFile -Value "$OutFilePath"
        }
    }

}

# Output Number of files crated or updated
Write-Output "Created or Updated $CountOfFilesUpdated advancement override files"