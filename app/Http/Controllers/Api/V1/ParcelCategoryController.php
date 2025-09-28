<?php

namespace App\Http\Controllers\Api\V1;

use App\CentralLogics\Helpers;
use App\Http\Controllers\Controller;
use App\Models\ParcelCategory;
use Illuminate\Http\Request;

class ParcelCategoryController extends Controller
{
    public function index(Request $request){
        try {
            \Log::info('ParcelCategory API called');
            \Log::info('Module data: ' . json_encode(config('module.current_module_data')));
            
            $parcel_categories = ParcelCategory::
            when(config('module.current_module_data'), function($query){
                \Log::info('Filtering by module ID: ' . config('module.current_module_data')['id']);
                $query->module(config('module.current_module_data')['id']);
            })
            ->active()->get();
            
            \Log::info('Raw categories count: ' . $parcel_categories->count());
            
            $parcel_categories=Helpers::parcel_category_data_formatting($parcel_categories, true);
            
            \Log::info('Formatted categories count: ' . count($parcel_categories));
            
            return response()->json($parcel_categories, 200);
        } catch (\Exception $e) {
            \Log::error('ParcelCategory API error: ' . $e->getMessage());
            \Log::error('Stack trace: ' . $e->getTraceAsString());
            return response()->json([], 200);
        }
    }
}
