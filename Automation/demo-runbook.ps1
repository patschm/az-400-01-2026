Param(
    [string]$RG,
    [string]$VM
)

try
{
    $AzConnection = (Connect-AzAccount -Identity).context
}
catch
{
    Write-Output "No system Assigned Identity found"
    exit
}

$AzureContext = Set-AzContext -SubscriptionName $AzConnection.Subscription -DefaultProfile $AzConnection
$status = (Get-AzVM -ResourceGroupName $RG -Name $VM -Status -DefaultProfile $AzureContext).Statuses[1].Code

Write-Output "-- Beginning VM status: $status `r`n"

if ($status -eq "Powerstate/deallocated") {
    Start-AzVM -Name $VM -ResourceGroupName $RG -DefaultProfile $AzureContext
}
elseif ($status -eq "Powerstate/running") {
    Stop-AzVM -Name $VM -ResourceGroupName $RG -DefaultProfile $AzureContext -Force
}

$status = (Get-AzVM -ResourceGroupName $RG -Name $VM -Status -DefaultProfile $AzureContext).Statuses[1].Code  

Write-Output "-- Ending VM status: $status `r`n"

Write-Output "Account ID of current context: " $AzureContext.Account.Id