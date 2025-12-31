<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AdminSuratController extends Controller
{
    public function index()
{
    $pengajuan = DB::table('surat_pengajuan')
        ->join('users', 'surat_pengajuan.user_id', '=', 'users.id')
        ->select(
            'surat_pengajuan.*',
            'users.name' // ambil nama dari tabel users
        )
        ->get();

    return response()->json([
        'message' => 'Daftar pengajuan surat',
        'data' => $pengajuan
    ]);
}
}