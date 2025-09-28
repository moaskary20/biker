<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Storage;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

// Route for serving blog images directly
Route::get('/blog-image/{path}', function ($path) {
    $fullPath = storage_path('app/public/blog/' . $path);
    
    if (file_exists($fullPath)) {
        return response()->file($fullPath);
    }
    
    return response()->json(['error' => 'Image not found'], 404);
})->where('path', '.*')->name('blog-image');

// Route for serving blog images from public directory
Route::get('/images/blog/{type}/{filename}', function ($type, $filename) {
    $fullPath = public_path('images/blog/' . $type . '/' . $filename);
    
    if (file_exists($fullPath)) {
        return response()->file($fullPath);
    }
    
    return response()->json(['error' => 'Image not found'], 404);
})->name('blog-image-public');