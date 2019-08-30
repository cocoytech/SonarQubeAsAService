param(
    [string]
    $Location = "West Europe",
    [string]
    $SqlServerName = "sqlserv-sonarqubetest",
    [string]
    $SqlDatabase = "sqldb-sonarqubetest",
    [string]
    $SqlDatabaseAdmin = "sonaradmin",
    [string]
    $SqlDatabaseAdminPassword = "sonar2019!",
    [string]
    $DatabaseSku = "S0",
    [string]
    $AppServicePlanName = "ASP-SonarQubeTest",
    [string]
    $AppServiceSku = "S1",
    [string]
    $AppName = "WA-SonarQubeTest",
    [string]
    $Subscription = "SUBSCR_SIS_DWP_ALM_PROD",
    [string]
    $ResourceGroupName = "RG_SonarQubeTest02_DEV",

)

az account set --subscription $Subscription
az group create --name $ResourceGroupName --location $Location

az sql server create --name $SqlServerName --resource-group $ResourceGroupName --location $Location --admin-user `"$SqlDatabaseAdmin`" --admin-password `"$SqlDatabaseAdminPassword`"
az sql db create --resource-group $ResourceGroupName --server $SqlServerName --name $SqlDatabase --service-objective $DatabaseSku --collation "SQL_Latin1_General_CP1_CS_AS"
az sql server firewall-rule create --resource-group $ResourceGroupName --server $SqlServerName -n "AllowAllWindowsAzureIps" --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

az appservice plan create --resource-group $ResourceGroupName --name $AppServicePlanName --sku $AppServiceSku 
az webapp create --resource-group $ResourceGroupName --plan $AppServicePlanName --name $AppName --runtime "java|11|Tomcat|9.0"
az webapp config set --resource-group $ResourceGroupName --name $AppName --always-on true