<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AdminController extends Controller
{
    public function getStatistik()
    {
        // kalau tabel pendaftaran belum ada, jangan dipanggil
        $totalSurat = DB::table('surat_pengajuan')->count();
        $totalPengaduan = DB::table('pengaduan')->count();
        $totalUser = DB::table('users')->count();

        return response()->json([
            'surat' => $totalSurat,
            'pengaduan'   => $totalPengaduan,
            'user'        => $totalUser,
        ]);
    }

    public function getPengaduan()
{
    $pengaduan = DB::table('pengaduan')
        ->join('users', 'pengaduan.user_id', '=', 'users.id')
        ->select(
            'pengaduan.id',
            'users.name as user_name',
            'pengaduan.title',
            'pengaduan.location',
            'pengaduan.description',
            'pengaduan.status',
            'pengaduan.feedback',
            'pengaduan.created_at'
        )
        ->get();

    return response()->json($pengaduan);
}
}