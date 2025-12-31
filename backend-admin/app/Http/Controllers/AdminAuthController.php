<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\Admin;

class AdminAuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required',
            'password' => 'required'
        ]);

        $admin = Admin::where('username', $request->username)->first();

        if ($admin && Hash::check($request->password, $admin->password)) {
            // Sanctum: generate token untuk admin
            $token = $admin->createToken('admin-token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Login berhasil',
                'admin'   => $admin,
                'token'   => $token,
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Username atau password salah'
        ], 401);
    }
}