# Script PowerShell pour démarrer tous les services du TP
# Usage: .\start-services.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Démarrage des Microservices" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Fonction pour vérifier si un port est utilisé
function Test-Port {
    param([int]$Port)
    $connection = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue
    return $connection.TcpTestSucceeded
}

# Fonction pour démarrer un service
function Start-Service {
    param(
        [string]$ServiceName,
        [string]$ServicePath,
        [int]$Port
    )
    
    Write-Host "[$ServiceName] Vérification du port $Port..." -ForegroundColor Yellow
    if (Test-Port -Port $Port) {
        Write-Host "[$ServiceName] ⚠️  Le port $Port est déjà utilisé!" -ForegroundColor Red
        return $false
    }
    
    Write-Host "[$ServiceName] Démarrage..." -ForegroundColor Green
    $process = Start-Process -FilePath "mvn" -ArgumentList "spring-boot:run" -WorkingDirectory $ServicePath -PassThru -WindowStyle Normal
    Start-Sleep -Seconds 2
    Write-Host "[$ServiceName] ✅ Processus démarré (PID: $($process.Id))" -ForegroundColor Green
    return $true
}

# Vérification des prérequis
Write-Host "Vérification des prérequis..." -ForegroundColor Cyan
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "✅ Java: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Java n'est pas installé ou pas dans le PATH" -ForegroundColor Red
    exit 1
}

try {
    $mvnVersion = mvn -version 2>&1 | Select-String "Apache Maven"
    Write-Host "✅ Maven: $mvnVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Maven n'est pas installé ou pas dans le PATH" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Démarrage des Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Eureka Server
Write-Host "1️⃣  Eureka Server (Port 8761)" -ForegroundColor Magenta
Start-Service -ServiceName "EurekaServer" -ServicePath "EurekaServer" -Port 8761
Write-Host "   ⏳ Attente de 15 secondes pour le démarrage..." -ForegroundColor Yellow
Start-Sleep -Seconds 15
Write-Host ""

# 2. Service Client
Write-Host "2️⃣  Service Client (Port 8088)" -ForegroundColor Magenta
Start-Service -ServiceName "Service-Client" -ServicePath "Client" -Port 8088
Write-Host "   ⏳ Attente de 10 secondes pour le démarrage..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Write-Host ""

# 3. Service Voiture
Write-Host "3️⃣  Service Voiture (Port 8089)" -ForegroundColor Magenta
Start-Service -ServiceName "Service-Voiture" -ServicePath "Voiture" -Port 8089
Write-Host "   ⏳ Attente de 10 secondes pour le démarrage..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Write-Host ""

# 4. Gateway
Write-Host "4️⃣  Gateway (Port 8888)" -ForegroundColor Magenta
Start-Service -ServiceName "Gateway" -ServicePath "GateWay" -Port 8888
Write-Host "   ⏳ Attente de 10 secondes pour le démarrage..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ Tous les services sont démarrés!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🔍 Vérifications:" -ForegroundColor Cyan
Write-Host "   • Eureka Dashboard: http://localhost:8761" -ForegroundColor White
Write-Host "   • Service Client: http://localhost:8088/clients" -ForegroundColor White
Write-Host "   • Service Voiture: http://localhost:8089/voitures" -ForegroundColor White
Write-Host "   • Gateway: http://localhost:8888/clients" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Pour arrêter les services, fermez les fenêtres de terminal" -ForegroundColor Yellow
Write-Host ""

