<?php

namespace App\Imports;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class UsersImport implements ToModel, WithHeadingRow
{
    public int $inserted = 0;
    public int $skipped = 0;
    public array $errors = [];

    // Excel header harus: userID, nik, password, name, gender, phone, photo, role, address
    public function model(array $row)
    {
        try {
            // Minimal wajib
            if (
                empty($row['userid']) ||
                empty($row['password']) ||
                empty($row['name']) ||
                empty($row['role'])
            ) {
                $this->skipped++;
                $this->errors[] = "Baris dengan userID '".($row['userid'] ?? '')."' dilewati: kolom wajib kosong.";
                return null;
            }

            // Validasi role
            $validRoles = ['warga', 'rt', 'rw', 'security'];
            if (!in_array(strtolower($row['role']), $validRoles, true)) {
                $this->skipped++;
                $this->errors[] = "userID '{$row['userid']}': role tidak valid.";
                return null;
            }

            // Validasi gender (opsional)
            if (!empty($row['gender'])) {
                $gender = strtoupper($row['gender']);
                if (!in_array($gender, ['LAKI-LAKI', 'PEREMPUAN'], true)) {
                    $this->skipped++;
                    $this->errors[] = "userID '{$row['userid']}': gender tidak valid.";
                    return null;
                }
            }

            // Cek duplikasi userID
            if (User::where('userID', $row['userid'])->exists()) {
                $this->skipped++;
                $this->errors[] = "userID '{$row['userid']}': sudah ada, dilewati.";
                return null;
            }

            $this->inserted++;
            return new User([
                'userID' => $row['userid'],
                'nik' => $row['nik'] ?? null,
                'password' => Hash::make($row['password']),
                'name' => $row['name'],
                'gender' => !empty($row['gender']) ? strtoupper($row['gender']) : null,
                'phone' => $row['phone'] ?? null,
                'photo' => $row['photo'] ?? null,
                'role' => strtolower($row['role']),
                'address' => $row['address'] ?? null,
            ]);
        } catch (\Throwable $e) {
            $this->skipped++;
            $this->errors[] = "userID '".($row['userid'] ?? '')."': ".$e->getMessage();
            return null;
        }
    }
}