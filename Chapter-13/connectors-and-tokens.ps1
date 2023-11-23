##Set Connectors
$connectors = @(
    "Windows enterprise certificate",
    "Microsoft Endpoint Configuration Manager",
    "Windows 365 Partner connectors",
    "Windows data",
    "Apple VPP Tokens",
    "Managed Google Play",
    "Chrome Enterprise",
    "Firmware over-the-air (Zebra)",
    "Microsoft Defender for Endpoint",
    "Mobile Threat Defense",
    "Partner device management (JAMF)",
    "Partner compliance management",
    "TeamViewer connector",
    "ServiceNow connector",
    "Certificate connectors",
    "Derived Credentials"
)

##Select connector
$selectedconnector = $connectors | Out-GridView -Title "Select a connector to check" -PassThru

##Set URL from selected connector
switch ($selectedconnector) {
    "Windows enterprise certificate" {
        $url = "https://graph.microsoft.com/beta/deviceAppManagement/enterpriseCodeSigningCertificates"
    }
    "Microsoft Endpoint Configuration Manager" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/tenantAttachRBAC/getState?_=1694715926343"
    }
    "Windows 365 Partner connectors" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/dataProcessorServiceForWindowsFeaturesOnboarding"
    }
    "Apple VPP Tokens" {
        $url = "https://graph.microsoft.com/beta/deviceAppManagement/vppTokens"
    }
    "Managed Google Play" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/mobileThreatDefenseConnectors?`$select=id,lastHeartbeatDateTime,partnerState,androidEnabled,iosEnabled,windowsEnabled,macEnabled,androidMobileApplicationManagementEnabled,iosMobileApplicationManagementEnabled,windowsMobileApplicationManagementEnabled"
    }
    "Chrome Enterprise" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/chromeOSOnboardingSettings"
    }
    "Firmware over-the-air (Zebra)" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/zebraFotaConnector"
    }
    "Microsoft Defender for Endpoint" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/advancedThreatProtectionOnboardingStateSummary"
    }
    "Mobile Threat Defense" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/mobileThreatDefenseConnectors?`$select=id,lastHeartbeatDateTime,partnerState,androidEnabled,iosEnabled,windowsEnabled,macEnabled,androidMobileApplicationManagementEnabled,iosMobileApplicationManagementEnabled,windowsMobileApplicationManagementEnabled"
    }
    "Partner device management (JAMF)" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/deviceManagementPartners/007d2fff-e0dd-4b28-8595-cec005efe5cd"
    }
    "Partner compliance management" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/complianceManagementPartners"
    }
    "TeamViewer connector" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/remoteAssistancePartners"
    }
    "ServiceNow connector" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/serviceNowConnections"
    }
    "Certificate connectors" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/ndesConnectors"
    }
    "Derived Credentials" {
        $url = "https://graph.microsoft.com/beta/deviceManagement/derivedCredentials"
    }
    default {
        Write-Output "Invalid connector selected."
        Exit 1
    }
}

##Get connector
$output = Invoke-MgGraphRequest -Uri $url -Method Get -OutputType PSObject
if ($output.value) {
    $output = $output.value
}
else {
    $output = $output
}

$output | Out-GridView