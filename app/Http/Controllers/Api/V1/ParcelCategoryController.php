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
            \Log::info('ParcelCategoryController: Starting index method');
            \Log::info('ParcelCategoryController: Module config: ' . json_encode(config('module.current_module_data')));
            
            $query = ParcelCategory::query();
            
            if(config('module.current_module_data')) {
                $query->where('module_id', config('module.current_module_data')['id']);
                \Log::info('ParcelCategoryController: Filtering by module_id: ' . config('module.current_module_data')['id']);
            } else {
                \Log::info('ParcelCategoryController: No module config, getting all categories');
            }
            
            $parcel_categories = $query->where('status', 1)->get();
            \Log::info('ParcelCategoryController: Found ' . $parcel_categories->count() . ' categories');
            
            foreach($parcel_categories as $category) {
                \Log::info('Category ' . $category->id . ': ' . $category->name . ' - Module ID: ' . $category->module_id);
            }
            
            $parcel_categories=Helpers::parcel_category_data_formatting($parcel_categories, true);
            \Log::info('ParcelCategoryController: After formatting, count: ' . count($parcel_categories));
            
            return response()->json($parcel_categories, 200);
        } catch (\Exception $e) {
            \Log::error('ParcelCategoryController: Error - ' . $e->getMessage());
            info($e->getMessage());
            return response()->json([], 200);
        }
    }
}
