function Import-ArtifactGAV()
{
	[CmdletBinding()]
	param
	(
		[string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$EndpointUrl,
		[string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Repository,
		[string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Group,
		[string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Artifact,
		[string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Version,
		[string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Packaging,
		[string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$PackagePath,
		[System.Management.Automation.PSCredential][parameter(Mandatory = $true)]$Credential
	)
	BEGIN
	{
		if (-not (Test-Path $PackagePath))
		{
			$errorMessage = ("Package file {0} missing or unable to read." -f $packagePath)
			$exception =  New-Object System.Exception $errorMessage
			$errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, 'XLDPkgUpload', ([System.Management.Automation.ErrorCategory]::InvalidArgument), $packagePath
			$PSCmdlet.ThrowTerminatingError($errorRecord)
		}

		Add-Type -AssemblyName System.Net.Http
	}
	PROCESS
	{
		$repoContent = CreateStringContent "r" $Repository
		$groupContent = CreateStringContent "g" $Group
		$artifactContent = CreateStringContent "a" $Artifact
		$versionContent = CreateStringContent "v" $Version
		$packagingContent = CreateStringContent "p" $Packaging
		$streamContent = CreateStreamContent $PackagePath

		$content = New-Object -TypeName System.Net.Http.MultipartFormDataContent
		$content.Add($repoContent)
		$content.Add($groupContent)
		$content.Add($artifactContent)
		$content.Add($versionContent)
		$content.Add($packagingContent)
		$content.Add($streamContent)

		$httpClientHandler = GetHttpClientHandler $Credential

		return PostArtifact $EndpointUrl $httpClientHandler $content
	}
	END { }
}