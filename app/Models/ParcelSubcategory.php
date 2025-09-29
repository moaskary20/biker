<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ParcelSubcategory extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'image',
        'parcel_category_id',
        'status'
    ];

    protected $casts = [
        'status' => 'boolean'
    ];

    public function category()
    {
        return $this->belongsTo(ParcelCategory::class, 'parcel_category_id');
    }
}