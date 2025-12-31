<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminAuthController;
use App\Http\Controllers\AdminUserController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\AdminSuratController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Route bawaan Sanctum untuk cek user login
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Fitur 1: Login admin
Route::post('/admin/login', [AdminAuthController::class, 'login']);

// Fitur 2: Manajemen pendaftar / user
Route::get('/admin/users', [AdminUserController::class, 'index']);
Route::post('/admin/users', [AdminUserController::class, 'store']);
Route::post('/admin/users/import', [AdminUserController::class, 'import']);
Route::get('/admin/users/template', [AdminUserController::class, 'downloadTemplate']);

Route::get('/admin/statistik', [AdminController::class, 'getStatistik']);

Route::get('/admin/pengaduan', [AdminController::class, 'getPengaduan']);

Route::get('/admin/pengajuan-surat', [AdminSuratController::class, 'index']);