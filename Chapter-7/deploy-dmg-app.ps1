$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/"
$name = "Adobe Acrobat Reader"
$description = "Adobe Acrobat Reader"

$installgroupid = "000000-0000-0000-0000-000000000000"
$unistallgroupid = "000000-0000-0000-0000-000000000000"

$dmgpath = "c:\temp\AcroRdrDC_2300320201_MUI.dmg"
##Get Filename from path
$filename = [System.IO.Path]::GetFileName($dmgpath)

##Get just the path
$filepath = [System.IO.Path]::GetDirectoryName($dmgpath)

##Add filename with encryption at the start
$encryptedfilename = "encrypted_" + $filename

##Add to path
$encryptedfilepath = $filepath + "\" + $encryptedfilename


$json = @"
{
	"@odata.type": "#microsoft.graph.macOSDmgApp",
	"categories": [],
	"description": "$description",
	"developer": "",
	"displayName": "$name",
	"fileName": "$filename",
	"ignoreVersionDetection": true,
	"includedApps": [
		{
			"bundleId": "com.adobe.Reader",
			"bundleVersion": "2300320201"
		}
	],
	"informationUrl": "",
	"isFeatured": false,
	"minimumSupportedOperatingSystem": {
		"v10_13": true
	},
	"notes": "",
	"owner": "",
	"primaryBundleId": "com.adobe.Reader",
	"primaryBundleVersion": "2300320201",
	"privacyInformationUrl": "",
	"publisher": "Adobe",
	"roleScopeTagIds": []
}
"@

$mobileapp = Invoke-MgGraphRequest -Uri $url -Method Post -Body $json -ContentType "application/json" -OutputType PSObject


###############################################################################################################
######                                          Add Functions                                            ######
###############################################################################################################        
function CloneObject($object) {
        
    $stream = New-Object IO.MemoryStream
    $formatter = New-Object Runtime.Serialization.Formatters.Binary.BinaryFormatter
    $formatter.Serialize($stream, $object)
    $stream.Position = 0
    $formatter.Deserialize($stream)
}
        
####################################################
        
function UploadAzureStorageChunk($sasUri, $id, $body) {
        
    $uri = "$sasUri&comp=block&blockid=$id"
    $request = "PUT $uri"
        
    $iso = [System.Text.Encoding]::GetEncoding("iso-8859-1")
    $encodedBody = $iso.GetString($body)
    $headers = @{
        "x-ms-blob-type" = "BlockBlob"
    }
        
    if ($logRequestUris) { Write-Verbose $request }
    if ($logHeaders) { WriteHeaders $headers }
        
    try {
        Invoke-WebRequest $uri -Method Put -Headers $headers -Body $encodedBody
    }
    catch {
        Write-Error $request
        Write-Error $_.Exception.Message
        throw
    }
        
}
        
####################################################
        
function FinalizeAzureStorageUpload($sasUri, $ids) {
        
    $uri = "$sasUri&comp=blocklist"
    $request = "PUT $uri"
        
    $xml = '<?xml version="1.0" encoding="utf-8"?><BlockList>'
    foreach ($id in $ids) {
        $xml += "<Latest>$id</Latest>"
    }
    $xml += '</BlockList>'
        
    if ($logRequestUris) { Write-Verbose $request }
    if ($logContent) { Write-Verbose $xml }
        
    try {
        Invoke-RestMethod $uri -Method Put -Body $xml
    }
    catch {
        Write-Error $request
        Write-Error $_.Exception.Message
        throw
    }
}
        
####################################################
        
function UploadFileToAzureStorage($sasUri, $filepath, $fileUri) {
        
    try {
        
        $chunkSizeInBytes = 1024l * 1024l * $azureStorageUploadChunkSizeInMb
                
        # Start the timer for SAS URI renewal.
        $sasRenewalTimer = [System.Diagnostics.Stopwatch]::StartNew()
                
        # Find the file size and open the file.
        $fileSize = (Get-Item $filepath).length
        $chunks = [Math]::Ceiling($fileSize / $chunkSizeInBytes)
        $reader = New-Object System.IO.BinaryReader([System.IO.File]::Open($filepath, [System.IO.FileMode]::Open))
        $reader.BaseStream.Seek(0, [System.IO.SeekOrigin]::Begin)
                
        # Upload each chunk. Check whether a SAS URI renewal is required after each chunk is uploaded and renew if needed.
        $ids = @()
        
        for ($chunk = 0; $chunk -lt $chunks; $chunk++) {
        
            $id = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($chunk.ToString("0000")))
            $ids += $id
        
            $start = $chunk * $chunkSizeInBytes
            $length = [Math]::Min($chunkSizeInBytes, $fileSize - $start)
            $bytes = $reader.ReadBytes($length)
                    
            $currentChunk = $chunk + 1			
        
            Write-Progress -Activity "Uploading File to Azure Storage" -status "Uploading chunk $currentChunk of $chunks" `
                -percentComplete ($currentChunk / $chunks * 100)
        
            UploadAzureStorageChunk $sasUri $id $bytes
                    
            # Renew the SAS URI if 7 minutes have elapsed since the upload started or was renewed last.
            if ($currentChunk -lt $chunks -and $sasRenewalTimer.ElapsedMilliseconds -ge 450000) {
        
                RenewAzureStorageUpload $fileUri
                $sasRenewalTimer.Restart()
                    
            }
        
        }
        
        Write-Progress -Completed -Activity "Uploading File to Azure Storage"
        
        $reader.Close()
        
    }
        
    finally {
        
        if ($null -ne $reader) { $reader.Dispose() }
            
    }
            
    # Finalize the upload.
    FinalizeAzureStorageUpload $sasUri $ids
        
}
        
####################################################
        
function RenewAzureStorageUpload($fileUri) {
        
    $renewalUri = "$fileUri/renewUpload"
    $actionBody = ""
    Invoke-MgGraphRequest -method POST -Uri $renewalUri -Body $actionBody
            
    Start-WaitForFileProcessing $fileUri "AzureStorageUriRenewal" $azureStorageRenewSasUriBackOffTimeInSeconds
        
}
        
####################################################
        
function Start-WaitForFileProcessing($fileUri, $stage) {
    
    $attempts = 600
    $waitTimeInSeconds = 10
        
    $successState = "$($stage)Success"
    $pendingState = "$($stage)Pending"
        
    $file = $null
    while ($attempts -gt 0) {
        $file = Invoke-MgGraphRequest -Method GET -Uri $fileUri
        
        if ($file.uploadState -eq $successState) {
            break
        }
        elseif ($file.uploadState -ne $pendingState) {
            Write-Error $_.Exception.Message
            throw "File upload state is not success: $($file.uploadState)"
        }
        
        Start-Sleep $waitTimeInSeconds
        $attempts--
    }
        
    if ($null -eq $file -or $file.uploadState -ne $successState) {
        throw "File request did not complete in the allotted time."
    }
        
    $file
}
        
####################################################
        
function GetAppFileBody($name, $size, $sizeEncrypted, $manifest) {
        
    $body = @{ "@odata.type" = "#microsoft.graph.mobileAppContentFile" }
    $body.name = $name
    $body.size = $size
    $body.manifest = $null
    $body.isDependency = $false
    $body.sizeEncrypted = $sizeEncrypted
    $body
}
        
####################################################
        
function GetAppCommitBody($contentVersionId, $LobType) {
        
    $body = @{ "@odata.type" = "#$LobType" }
    $body.committedContentVersion = $contentVersionId
        
    $body
        
}
        
####################################################
        
Function Test-SourceFile() {
        
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $SourceFile
    )
        
    try {
        
        if (!(test-path "$SourceFile")) {
        
            Write-Error "Source File '$sourceFile' doesn't exist..."
            throw
        
        }
        
    }
        
    catch {
        
        Write-Error $_.Exception.Message
        break
        
    }
        
}
        
####################################################


$LOBType = "microsoft.graph.macOSDmgApp"

$logRequestUris = $true
$logHeaders = $false
$logContent = $true

$azureStorageUploadChunkSizeInMb = 6l

$sleep = 30

# Get the content version for the new app (this will always be 1 until the new app is committed).
Write-Verbose "Creating Content Version in the service for the application..."
$appId = $mobileApp.id
$contentVersionUri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appId/$LOBType/contentVersions"
$contentVersion = Invoke-MgGraphRequest -method POST -Uri $contentVersionUri -Body "{}"


$Size = (Get-Item "$dmgpath").Length

#####CREATE ENCRYPTION INFO

$random = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
$bytes = New-Object byte[] 32
$random.GetBytes($bytes)

$bytes2 = New-Object byte[] 16
$random2.GetBytes($bytes2)
$encryptionkey = [System.BitConverter]::ToString($bytes) -replace "-"
$macKey = [System.BitConverter]::ToString($bytes) -replace "-"

$iv = [byte[]]::CreateInstance(16, 0)

# Read the file contents as bytes
$fileBytes = [System.IO.File]::ReadAllBytes($dmgpath)

# Create a new AES object with the encryption key and IV
$aes = New-Object System.Security.Cryptography.AesCryptoServiceProvider
$aes.Key = [System.Convert]::FromHexString($encryptionKey)
$aes.IV = $iv

# Create a new HMAC-SHA256 object with the MAC key
$hmac = New-Object System.Security.Cryptography.HMACSHA256
$hmac.Key = [System.Convert]::FromHexString($macKey)

# Encrypt the file contents using AES-CBC mode
$encryptor = $aes.CreateEncryptor()
$encryptedBytes = $encryptor.TransformFinalBlock($fileBytes, 0, $fileBytes.Length)

# Compute the HMAC-SHA256 of the encrypted bytes
$macBytes = $hmac.ComputeHash($encryptedBytes)

# Concatenate the IV, encrypted bytes, and MAC bytes
$outputBytes = $iv + $encryptedBytes + $macBytes

# Write the output bytes to a file
[System.IO.File]::WriteAllBytes($encryptedFilePath, $outputBytes)

Write-Host "File encrypted and written to $encryptedFilePath"

##Create base64 filedigest
$filedigest = [System.Convert]::ToBase64String((Get-FileHash $encryptedFilePath -Algorithm SHA256).Hash)

##Convert aes.key to base64
$baseencryptionkey = [System.Convert]::ToBase64String($aes.Key)

##Convert aes.iv to base64
$baseinitializationvector = [System.Convert]::ToBase64String($aes.IV)

##Convert hmac.key to base64
$basemackey = [System.Convert]::ToBase64String($hmac.key)

##Convert macBytes to Base64
$basemac = [System.Convert]::ToBase64String($macBytes)

$fileEncryptionInfo = @"
{
    "fileEncryptionInfo":
    {
        "encryptionKey":"$baseencryptionkey",
        "initializationVector":"$baseinitializationvector",
        "mac":"$basemac",
        "macKey":"$basemackey",
        "profileIdentifier":"ProfileVersion1",
        "fileDigest":"$filedigest",
        "fileDigestAlgorithm":"SHA256"
    }
}
"@

$Size = (Get-Item "$encryptedfilepath").Length

# Create a new file for the app.
Write-Verbose "Creating a new file entry in Azure for the upload..."
$contentVersionId = $contentVersion.id
$fileBody = GetAppFileBody "$FileName" $Size $sizeEncrypted $null
$filesUri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appId/$LOBType/contentVersions/$contentVersionId/files"
$file = Invoke-MgGraphRequest -Method POST -Uri $filesUri -Body ($fileBody | ConvertTo-Json)
	
# Wait for the service to process the new file request.
Write-Verbose "Waiting for the file entry URI to be created..."
$fileId = $file.id
$fileUri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appId/$LOBType/contentVersions/$contentVersionId/files/$fileId"
$file = Start-WaitForFileProcessing $fileUri "AzureStorageUriRequest"

# Upload the content to Azure Storage.
Write-Verbose "Uploading file to Azure Storage..."

UploadFileToAzureStorage $file.azureStorageUri "$encryptedfilepath" $fileUri


# Commit the file.
Write-Verbose "Committing the file into Azure Storage..."
$commitFileUri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appId/$LOBType/contentVersions/$contentVersionId/files/$fileId/commit"




Invoke-MgGraphRequest -Uri $commitFileUri -Method POST -Body ($fileEncryptionInfo)

# Wait for the service to process the commit file request.
Write-Verbose "Waiting for the service to process the commit file request..."
$file = Start-WaitForFileProcessing $fileUri "CommitFile"

# Commit the app.
Write-Verbose "Committing the file into Azure Storage..."
$commitAppUri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appId"
$commitAppBody = GetAppCommitBody $contentVersionId $LOBType
Invoke-MgGraphRequest -Method PATCH -Uri $commitAppUri -Body ($commitAppBody | ConvertTo-Json)

foreach ($i in 0..$sleep) {
	Write-Progress -Activity "Sleeping for $($sleep-$i) seconds" -PercentComplete ($i / $sleep * 100) -SecondsRemaining ($sleep - $i)
	Start-Sleep -s 1
}            






$url = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appid/assign"

$json = @"
{
    "mobileAppAssignments":
    [
        {
            "@odata.type":"#microsoft.graph.mobileAppAssignment",
            "target":
            {
                "@odata.type":"#microsoft.graph.groupAssignmentTarget",
                "groupId":"$installgroupid"
            },
            "intent":"Required","settings":null
        },
        {
            "@odata.type":"#microsoft.graph.mobileAppAssignment",
            "target":
            {
                "@odata.type":"#microsoft.graph.groupAssignmentTarget",
                "groupId":"$uninstallgroupid"
            },
            "intent":"Uninstall","settings":null
        }
        ]
    }
"@

Invoke-MgGraphRequest -Url $url -Method Post -Body $json -ContentType "application/json"