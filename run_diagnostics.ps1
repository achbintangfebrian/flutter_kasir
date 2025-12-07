# Smart Cashier API Diagnostics Script for PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Smart Cashier API Connection Diagnostics" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Checking if Flutter is installed..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version
    Write-Host "✅ Flutter is installed" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ Flutter is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Flutter and add it to your PATH" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host "Checking if Dart is available..." -ForegroundColor Yellow
try {
    $dartVersion = dart --version
    Write-Host "✅ Dart is available" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ Dart is not available" -ForegroundColor Red
    Write-Host "This is unusual since Flutter includes Dart" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host "Running API URL finder..." -ForegroundColor Yellow
Write-Host "This will test common Laravel API URL patterns" -ForegroundColor Yellow
Write-Host ""
dart find_correct_api_url.dart

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Look for a URL that shows 'VALID API ENDPOINT FOUND'" -ForegroundColor Cyan
Write-Host "2. Update lib/services/api_service.dart with that URL" -ForegroundColor Cyan
Write-Host "3. Make sure your Laravel backend is running" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")