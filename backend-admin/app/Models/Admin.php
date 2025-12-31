<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class Admin extends Authenticatable
{
    use HasApiTokens; // penting supaya bisa createToken()

    protected $table = 'admins'; // pastikan tabelnya 'admins'

    protected $fillable = ['username', 'password'];

    protected $hidden = ['password'];
}