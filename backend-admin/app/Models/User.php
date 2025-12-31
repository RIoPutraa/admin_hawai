<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable; // jika pakai auth
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use HasFactory, Notifiable;

    protected $fillable = [
        'userID',
        'nik',
        'password',
        'name',
        'gender',
        'phone',
        'photo',
        'role',
        'address',
    ];

    protected $hidden = [
        'password',
    ];
}