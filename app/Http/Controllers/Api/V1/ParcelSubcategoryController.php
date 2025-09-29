<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\ParcelSubcategory;
use Illuminate\Http\Request;

class ParcelSubcategoryController extends Controller
{
    public function index(Request $request, $categoryId = null)
    {
        try {
            $query = ParcelSubcategory::where('status', 1);
            
            if ($categoryId) {
                $query->where('parcel_category_id', $categoryId);
            }
            
            $subcategories = $query->get();
            
            return response()->json($subcategories, 200);
        } catch (\Exception $e) {
            \Log::error('ParcelSubcategoryController: Error - ' . $e->getMessage());
            return response()->json([], 200);
        }
    }
}