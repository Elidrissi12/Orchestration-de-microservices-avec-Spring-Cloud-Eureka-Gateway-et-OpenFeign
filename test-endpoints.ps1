# Script PowerShell pour tester les endpoints du TP
# Usage: .\test-endpoints.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Tests des Endpoints" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Fonction pour tester un endpoint
function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Url,
        [string]$Method = "GET",
        [string]$Body = $null
    )
    
    Write-Host "[TEST] $Name" -ForegroundColor Yellow
    Write-Host "       $Method $Url" -ForegroundColor Gray
    
    try {
        if ($Method -eq "GET") {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -ErrorAction Stop
        } else {
            $headers = @{"Content-Type" = "application/json"}
            if ($Body) {
                $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $headers -Body $Body -ErrorAction Stop
            } else {
                $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $headers -ErrorAction Stop
            }
        }
        
        Write-Host "       ✅ Succès" -ForegroundColor Green
        $response | ConvertTo-Json -Depth 5 | Write-Host -ForegroundColor White
        Write-Host ""
        return $true
    } catch {
        Write-Host "       ❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        return $false
    }
}

# Tests via Gateway
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Tests via GATEWAY (Port 8888)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Test-Endpoint -Name "Liste des clients" -Url "http://localhost:8888/clients"
Test-Endpoint -Name "Client par ID (1)" -Url "http://localhost:8888/client/1"
Test-Endpoint -Name "Liste des voitures" -Url "http://localhost:8888/voitures"
Test-Endpoint -Name "Voiture par ID (1)" -Url "http://localhost:8888/voitures/1"
Test-Endpoint -Name "Voitures du client 1" -Url "http://localhost:8888/voitures/client/1"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Tests Directs (Services)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Test-Endpoint -Name "Service Client - Liste" -Url "http://localhost:8088/clients"
Test-Endpoint -Name "Service Voiture - Liste" -Url "http://localhost:8089/voitures"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Tests Terminés" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

