<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\IOFactory;
use Symfony\Component\HttpFoundation\StreamedResponse;

class AdminUserController extends Controller
{
    // List semua user
    public function index()
    {
        return response()->json(User::all());
    }

    // Tambah user manual
    public function store(Request $request)
    {
        $validated = $request->validate([
            'userID' => 'required|string',
            'nik' => 'required|string|unique:users,nik',
            'name' => 'required|string|max:255',
            'password' => 'required|string|min:6',
            'gender' => 'required|string',
            'phone' => 'nullable|string|max:20',
            'role' => 'required|string',
            'address' => 'nullable|string',
        ]);

        $user = User::create([
            'userID' => $validated['userID'],
            'nik' => $validated['nik'],
            'name' => $validated['name'],
            'password' => Hash::make($validated['password']),
            'gender' => $validated['gender'],
            'phone' => $validated['phone'] ?? null,
            'role' => $validated['role'],
            'address' => $validated['address'] ?? null,
        ]);

        return response()->json([
            'message' => 'User berhasil ditambahkan',
            'user' => $user
        ], 201);
    }

    // Download template Excel
    public function downloadTemplate()
    {
        $spreadsheet = new Spreadsheet();
        $sheet = $spreadsheet->getActiveSheet();

        $headers = ['userID','nik','password','name','gender','phone','photo','role','address'];
        $sheet->fromArray($headers, null, 'A1');

        $sheet->fromArray(
            ['warga001','123456789','pass123','Budi Santoso','LAKI-LAKI','08123456789','','warga','Jl. Merdeka 10'],
            null,
            'A2'
        );

        $writer = new Xlsx($spreadsheet);

        return new StreamedResponse(function() use ($writer) {
            $writer->save('php://output');
        }, 200, [
            'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'Content-Disposition' => 'attachment;filename="template_users.xlsx"',
            'Cache-Control' => 'max-age=0',
        ]);
    }

    // Import Excel
    public function import(Request $request)
    {
        $request->validate([
            'file' => 'required|file|mimes:xlsx,xls,csv',
        ]);

        try {
            $spreadsheet = IOFactory::load($request->file('file')->getPathname());
            $sheet = $spreadsheet->getActiveSheet();
            $rows = $sheet->toArray();

            $inserted = 0;
            $skipped = 0;

            foreach (array_slice($rows, 1) as $row) {
                if (!empty($row[0]) && !empty($row[1])) {
                    User::create([
                        'userID' => $row[0],
                        'nik' => $row[1],
                        'password' => Hash::make($row[2] ?? 'default123'),
                        'name' => $row[3] ?? '',
                        'gender' => $row[4] ?? 'LAKI-LAKI',
                        'phone' => $row[5] ?? null,
                        'photo' => $row[6] ?? null,
                        'role' => $row[7] ?? 'warga',
                        'address' => $row[8] ?? null,
                    ]);
                    $inserted++;
                } else {
                    $skipped++;
                }
            }

            return response()->json([
                'message' => 'Import selesai',
                'inserted' => $inserted,
                'skipped' => $skipped,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Import gagal',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}