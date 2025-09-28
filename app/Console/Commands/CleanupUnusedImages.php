<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;
use App\Models\BlogPost;
use App\Models\BlogCategory;

class CleanupUnusedImages extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'blog:cleanup-images';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Clean up unused blog images from storage';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $this->info('Starting blog images cleanup...');

        $deletedCount = 0;

        // تنظيف صور المقالات
        $deletedCount += $this->cleanupBlogPostImages();

        // تنظيف صور الفئات
        $deletedCount += $this->cleanupBlogCategoryImages();

        $this->info("Cleanup completed. Deleted {$deletedCount} unused images.");

        return 0;
    }

    /**
     * تنظيف صور المقالات غير المستخدمة
     */
    private function cleanupBlogPostImages()
    {
        $this->info('Cleaning up blog post images...');
        
        $deletedCount = 0;
        $storagePath = 'blog/posts/';
        
        // الحصول على جميع الصور في مجلد المقالات
        $allImages = Storage::disk('public')->files($storagePath);
        
        // الحصول على جميع الصور المستخدمة في قاعدة البيانات
        $usedImages = BlogPost::pluck('featured_image')
            ->filter()
            ->map(function ($image) {
                // استخراج اسم الملف من الرابط الكامل
                if (str_starts_with($image, 'http')) {
                    return basename(parse_url($image, PHP_URL_PATH));
                }
                return basename($image);
            })
            ->toArray();

        foreach ($allImages as $imagePath) {
            $filename = basename($imagePath);
            
            // إذا كانت الصورة غير مستخدمة
            if (!in_array($filename, $usedImages)) {
                try {
                    if (Storage::disk('public')->delete($imagePath)) {
                        $this->line("Deleted unused image: {$filename}");
                        $deletedCount++;
                    }
                } catch (\Exception $e) {
                    $this->error("Failed to delete {$filename}: " . $e->getMessage());
                }
            }
        }

        return $deletedCount;
    }

    /**
     * تنظيف صور الفئات غير المستخدمة
     */
    private function cleanupBlogCategoryImages()
    {
        $this->info('Cleaning up blog category images...');
        
        $deletedCount = 0;
        $storagePath = 'blog/categories/';
        
        // الحصول على جميع الصور في مجلد الفئات
        $allImages = Storage::disk('public')->files($storagePath);
        
        // الحصول على جميع الصور المستخدمة في قاعدة البيانات
        $usedImages = BlogCategory::pluck('image')
            ->filter()
            ->map(function ($image) {
                // استخراج اسم الملف من الرابط الكامل
                if (str_starts_with($image, 'http')) {
                    return basename(parse_url($image, PHP_URL_PATH));
                }
                return basename($image);
            })
            ->toArray();

        foreach ($allImages as $imagePath) {
            $filename = basename($imagePath);
            
            // إذا كانت الصورة غير مستخدمة
            if (!in_array($filename, $usedImages)) {
                try {
                    if (Storage::disk('public')->delete($imagePath)) {
                        $this->line("Deleted unused image: {$filename}");
                        $deletedCount++;
                    }
                } catch (\Exception $e) {
                    $this->error("Failed to delete {$filename}: " . $e->getMessage());
                }
            }
        }

        return $deletedCount;
    }
}
