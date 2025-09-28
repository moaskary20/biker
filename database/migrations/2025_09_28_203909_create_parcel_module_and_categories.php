<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // إنشاء Parcel Module إذا لم يكن موجوداً
        $parcelModule = DB::table('modules')->where('module_type', 'parcel')->first();
        
        if (!$parcelModule) {
            $moduleId = DB::table('modules')->insertGetId([
                'module_name' => 'Parcel Module',
                'module_type' => 'parcel',
                'thumbnail' => 'parcel.png',
                'status' => 1,
                'stores_count' => 0,
                'icon' => 'parcel_icon.png',
                'theme_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        } else {
            $moduleId = $parcelModule->id;
        }

        // إنشاء Parcel Categories إذا لم تكن موجودة
        $existingCategories = DB::table('parcel_categories')->count();
        
        if ($existingCategories == 0) {
            $categories = [
                [
                    'name' => 'Emergency Delivery',
                    'description' => 'Fast emergency delivery service',
                    'image' => 'emergency.png',
                    'status' => 1,
                    'module_id' => $moduleId,
                    'parcel_per_km_shipping_charge' => 2.0,
                    'parcel_minimum_shipping_charge' => 10.0,
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Standard Delivery',
                    'description' => 'Standard delivery service',
                    'image' => 'standard.png',
                    'status' => 1,
                    'module_id' => $moduleId,
                    'parcel_per_km_shipping_charge' => 1.5,
                    'parcel_minimum_shipping_charge' => 8.0,
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Express Delivery',
                    'description' => 'Express delivery service',
                    'image' => 'express.png',
                    'status' => 1,
                    'module_id' => $moduleId,
                    'parcel_per_km_shipping_charge' => 2.5,
                    'parcel_minimum_shipping_charge' => 15.0,
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Heavy Items',
                    'description' => 'Heavy items delivery service',
                    'image' => 'heavy.png',
                    'status' => 1,
                    'module_id' => $moduleId,
                    'parcel_per_km_shipping_charge' => 3.0,
                    'parcel_minimum_shipping_charge' => 20.0,
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Fragile Items',
                    'description' => 'Fragile items delivery service',
                    'image' => 'fragile.png',
                    'status' => 1,
                    'module_id' => $moduleId,
                    'parcel_per_km_shipping_charge' => 2.8,
                    'parcel_minimum_shipping_charge' => 18.0,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]
            ];

            DB::table('parcel_categories')->insert($categories);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // حذف Parcel Categories
        DB::table('parcel_categories')->where('module_id', function($query) {
            $query->select('id')
                  ->from('modules')
                  ->where('module_type', 'parcel');
        })->delete();

        // حذف Parcel Module
        DB::table('modules')->where('module_type', 'parcel')->delete();
    }
};