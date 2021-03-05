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
		$params = @{
		Uri = "http://$EndpointUrl/service/rest/v1/components?repository=$Repository"
		Method = "POST"
		Headers =@{
			ContentType = "application/$Packaging"
		}
			
		}
		
		$form = @{
		"maven2.generate-pom" ='true'
		"maven2.groupId" = $Group
		"maven2.artifactId" = $Packaging
		"version" = $version
		"maven2.asset1" = Get-Item -Path $PackagePath
		"maven.asset1.extention" = $Packaging
		}
		Invoke-WebRequest @params -Form $form -Credential $Credential -Authentication Basic

		
	}
	END { }
}
