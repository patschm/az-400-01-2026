# Sign in to your Azure subscription
$sub = Get-AzSubscription -ErrorAction SilentlyContinue
if(-not ($sub)) {
    Connect-AzAccount
}

$resourceGroup = "automation-rg"
$automationAccount = "ps-automon"
$userAssignedManagedIdentity = "ps-automin-identity"

$role1 = "DevTest Labs User"

$SAMI = (Get-AzAutomationAccount -ResourceGroupName $resourceGroup -Name $automationAccount).Identity.PrincipalId
New-AzRoleAssignment -ObjectId $SAMI -ResourceGroupName $resourceGroup -RoleDefinitionName $role1

$UAMI = (Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroup -Name $userAssignedManagedIdentity).PrincipalId
New-AzRoleAssignment -ObjectId $UAMI -ResourceGroupName $resourceGroup -RoleDefinitionName $role1

$role2 = "Reader"
New-AzRoleAssignment -ObjectId $SAMI -ResourceGroupName $resourceGroup -RoleDefinitionName $role2