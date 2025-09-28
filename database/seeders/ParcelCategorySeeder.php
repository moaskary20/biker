<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\Module;
use App\Models\ParcelCategory;

class ParcelCategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // إنشاء أو العثور على Parcel Module
        $parcelModule = Module::firstOrCreate(
            ['module_type' => 'parcel'],
            [
                'module_name' => 'Parcel Module',
                'module_type' => 'parcel',
                'thumbnail' => 'parcel.png',
                'status' => 1,
                'stores_count' => 0,
                'icon' => 'parcel_icon.png',
                'theme_id' => 1,
            ]
        );

        // إنشاء Parcel Categories
        $categories = [
            [
                'name' => 'Emergency Delivery',
                'description' => 'Fast emergency delivery service',
                'image' => 'emergency.png',
                'status' => 1,
                'module_id' => $parcelModule->id,
                'parcel_per_km_shipping_charge' => 2.0,
                'parcel_minimum_shipping_charge' => 10.0,
            ],
            [
                'name' => 'Standard Delivery',
                'description' => 'Standard delivery service',
                'image' => 'standard.png',
                'status' => 1,
                'module_id' => $parcelModule->id,
                'parcel_per_km_shipping_charge' => 1.5,
                'parcel_minimum_shipping_charge' => 8.0,
            ],
            [
                'name' => 'Express Delivery',
                'description' => 'Express delivery service',
                'image' => 'express.png',
                'status' => 1,
                'module_id' => $parcelModule->id,
                'parcel_per_km_shipping_charge' => 2.5,
                'parcel_minimum_shipping_charge' => 15.0,
            ],
            [
                'name' => 'Heavy Items',
                'description' => 'Heavy items delivery service',
                'image' => 'heavy.png',
                'status' => 1,
                'module_id' => $parcelModule->id,
                'parcel_per_km_shipping_charge' => 3.0,
                'parcel_minimum_shipping_charge' => 20.0,
            ],
            [
                'name' => 'Fragile Items',
                'description' => 'Fragile items delivery service',
                'image' => 'fragile.png',
                'status' => 1,
                'module_id' => $parcelModule->id,
                'parcel_per_km_shipping_charge' => 2.8,
                'parcel_minimum_shipping_charge' => 18.0,
            ]
        ];

        foreach ($categories as $categoryData) {
            ParcelCategory::firstOrCreate(
                [
                    'name' => $categoryData['name'],
                    'module_id' => $categoryData['module_id']
                ],
                $categoryData
            );
        }

        $this->command->info('Parcel Module and Categories created successfully!');
    }
}