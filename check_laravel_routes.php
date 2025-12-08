<?php
/**
 * Simple script to check if required Laravel API routes are defined
 * 
 * To use this script:
 * 1. Save it in your Laravel project root directory
 * 2. Run: php check_laravel_routes.php
 */

// Check if we're in a Laravel project
if (!file_exists('artisan')) {
    echo "❌ Error: This script must be run from your Laravel project root directory\n";
    echo "   Please navigate to your Laravel project folder and try again.\n";
    exit(1);
}

echo "=== Laravel API Route Checker ===\n\n";

// Check if routes/api.php exists
if (!file_exists('routes/api.php')) {
    echo "❌ Error: routes/api.php file not found\n";
    echo "   Make sure you're in the correct Laravel project directory.\n";
    exit(1);
}

echo "✅ Found routes/api.php file\n";

// Check for required routes (excluding login/register as they are not used)
$requiredRoutes = [
    // Login and register routes have been removed as they are not used in the application
];

$missingRoutes = [];

foreach ($requiredRoutes as $route => $method) {
    $pattern = "/Route::{$method}\(['\"]{$route}['\"]/";
    
    if (preg_match($pattern, $routesContent)) {
        echo "✅ Found {$method} {$route} route\n";
    } else {
        echo "❌ Missing {$method} {$route} route\n";
        $missingRoutes[] = "{$method} {$route}";
    }
}

if (empty($missingRoutes)) {
    echo "\n🎉 All required API routes are defined!\n";
    echo "Your Laravel backend should work with the kasir_bintang app.\n";
} else {
    echo "\n⚠️  Missing routes detected:\n";
    foreach ($missingRoutes as $route) {
        echo "   - {$route}\n";
    }
}

echo "\n=== Route Check Complete ===\n";
?>