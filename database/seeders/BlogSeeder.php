<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\BlogCategory;
use App\Models\BlogPost;
use App\Models\BlogComment;
use Illuminate\Support\Str;

class BlogSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create blog categories
        $categories = [
            [
                'name' => 'Technology',
                'slug' => 'technology',
                'description' => 'Latest technology news and modern innovations',
                'image' => 'blog/categories/Mf2zbWXAUlqeyUFvmeJkOTZzr3K4YLPrlFyXnwQZ.jpg',
                'meta_title' => 'Technology - Biker Blog',
                'meta_description' => 'Discover the latest technology news and modern innovations in development and programming',
                'is_active' => true,
                'sort_order' => 1
            ],
            [
                'name' => 'Programming',
                'slug' => 'programming',
                'description' => 'Programming tutorials and modern development practices',
                'image' => 'blog/categories/5uxngos3j7RTSzaHWGR7TdkVvWLWFzrATB8NWAHD.jpg',
                'meta_title' => 'Programming & Development - Biker Blog',
                'meta_description' => 'Learn programming and development with the best tutorials and modern methods',
                'is_active' => true,
                'sort_order' => 2
            ],
            [
                'name' => 'Web Development',
                'slug' => 'web-development',
                'description' => 'Website and web application development',
                'image' => 'blog/categories/MsTDSw5StYezPMXEdmq7kTDxXCL2yEfJDElzhe8t.jpg',
                'meta_title' => 'Web Development - Biker Blog',
                'meta_description' => 'Learn website and web application development with latest technologies',
                'is_active' => true,
                'sort_order' => 3
            ],
            [
                'name' => 'News',
                'slug' => 'news',
                'description' => 'Latest news and updates in the tech world',
                'image' => 'blog/categories/ycU4Vu63CamuX40WKswBJVzfPR2GLVESWh3RF7A8.jpg',
                'meta_title' => 'Tech News - Biker Blog',
                'meta_description' => 'Follow the latest news and updates in technology and innovation',
                'is_active' => true,
                'sort_order' => 4
            ]
        ];

        foreach ($categories as $categoryData) {
            BlogCategory::create($categoryData);
        }

        // Create blog posts
        $posts = [
            [
                'title' => 'Introduction to Laravel 10: New Features',
                'slug' => 'laravel-10-introduction',
                'excerpt' => 'Discover the new features in Laravel 10 and the latest improvements in this beloved framework',
                'content' => '<h2>Introduction</h2><p>Laravel 10 comes with many new features and improvements that make application development easier and more efficient.</p><h3>New Features</h3><ul><li>Performance improvements</li><li>New security features</li><li>Database enhancements</li></ul><p>This article will show you the most important new features in Laravel 10.</p>',
                'featured_image' => 'blog/posts/IZQ4iwsl1XLZ2Qh3YYfAjLeZnp3nDbzkiWmQ6XdO.jpg',
                'category_id' => 1,
                'meta_title' => 'Laravel 10: New Features - Biker Blog',
                'meta_description' => 'Discover the new features in Laravel 10 and latest improvements',
                'tags' => ['Laravel', 'PHP', 'Web Development'],
                'is_published' => true,
                'is_featured' => true,
                'views_count' => 150,
                'likes_count' => 25,
                'comments_count' => 8,
                'published_at' => now()->subDays(2)
            ],
            [
                'title' => 'Best Practices in PHP Programming',
                'slug' => 'php-best-practices',
                'excerpt' => 'Learn the best practices in PHP programming to develop clean and efficient code',
                'content' => '<h2>Best Practices</h2><p>PHP programming requires following best practices to ensure clean and maintainable code.</p><h3>Important Tips</h3><ol><li>Use PSR-12 for coding standards</li><li>Write clear comments</li><li>Always test your code</li></ol>',
                'featured_image' => 'blog/posts/aBSi3brwIZltPYqPOPCBkliAxDXbdfmoJ3OF9Yo8.jpg',
                'category_id' => 2,
                'meta_title' => 'PHP Best Practices - Biker Blog',
                'meta_description' => 'Learn the best practices in PHP programming',
                'tags' => ['PHP', 'Programming', 'Best Practices'],
                'is_published' => true,
                'is_featured' => false,
                'views_count' => 89,
                'likes_count' => 15,
                'comments_count' => 5,
                'published_at' => now()->subDays(5)
            ],
            [
                'title' => 'Developing Modern User Interfaces with Vue.js',
                'slug' => 'vuejs-modern-ui',
                'excerpt' => 'Learn how to develop modern and attractive user interfaces using Vue.js',
                'content' => '<h2>Vue.js for Modern Interfaces</h2><p>Vue.js is a great framework for developing interactive user interfaces.</p><h3>Components</h3><p>Learn how to create reusable components.</p>',
                'featured_image' => 'blog/posts/opuqrltMTPhXhPj7iAyNtqhLjQNaNhkOZqSpnMLb.jpg',
                'category_id' => 3,
                'meta_title' => 'UI Development with Vue.js - Biker Blog',
                'meta_description' => 'Learn modern user interface development with Vue.js',
                'tags' => ['Vue.js', 'JavaScript', 'UI/UX'],
                'is_published' => true,
                'is_featured' => false,
                'views_count' => 120,
                'likes_count' => 20,
                'comments_count' => 6,
                'published_at' => now()->subDays(7)
            ],
            [
                'title' => 'Latest Artificial Intelligence News',
                'slug' => 'latest-ai-news',
                'excerpt' => 'Follow the latest artificial intelligence news and emerging technologies',
                'content' => '<h2>AI News</h2><p>Artificial intelligence has witnessed amazing developments recently.</p><h3>New Developments</h3><p>From ChatGPT to advanced applications, AI is changing the world.</p>',
                'featured_image' => 'blog/posts/Jae5oeh6m7uhIIfMgp57pSnl3BAZTmFJHDDlvtBL.jpg',
                'category_id' => 4,
                'meta_title' => 'AI News - Biker Blog',
                'meta_description' => 'Follow the latest artificial intelligence news and emerging technologies',
                'tags' => ['Artificial Intelligence', 'AI', 'Technology'],
                'is_published' => true,
                'is_featured' => true,
                'views_count' => 200,
                'likes_count' => 35,
                'comments_count' => 12,
                'published_at' => now()->subDays(1)
            ],
            [
                'title' => 'Complete Docker Guide for Developers',
                'slug' => 'docker-complete-guide',
                'excerpt' => 'Learn Docker from scratch to professional level with this comprehensive guide',
                'content' => '<h2>What is Docker?</h2><p>Docker is a containerization platform that makes application development and deployment easier.</p><h3>Benefits</h3><ul><li>Easy deployment</li><li>Consistent environment</li><li>Scalability</li></ul>',
                'featured_image' => 'blog/posts/IZQ4iwsl1XLZ2Qh3YYfAjLeZnp3nDbzkiWmQ6XdO.jpg',
                'category_id' => 1,
                'meta_title' => 'Complete Docker Guide - Biker Blog',
                'meta_description' => 'Learn Docker from scratch to professional level',
                'tags' => ['Docker', 'DevOps', 'Containers'],
                'is_published' => false, // Draft
                'is_featured' => false,
                'views_count' => 0,
                'likes_count' => 0,
                'comments_count' => 0,
                'published_at' => null
            ]
        ];

        foreach ($posts as $postData) {
            BlogPost::create($postData);
        }

        // Create sample comments
        $comments = [
            [
                'post_id' => 1,
                'name' => 'Ahmed Mohamed',
                'email' => 'ahmed@example.com',
                'comment' => 'Great article! Thank you for this useful information about Laravel 10.',
                'is_approved' => true,
                'is_spam' => false,
                'ip_address' => '192.168.1.1',
                'created_at' => now()->subHours(2)
            ],
            [
                'post_id' => 1,
                'parent_id' => 1,
                'name' => 'Laravel Developer',
                'email' => 'developer@example.com',
                'comment' => 'I agree with you, Laravel 10 is really great!',
                'is_approved' => true,
                'is_spam' => false,
                'ip_address' => '192.168.1.2',
                'created_at' => now()->subHour()
            ],
            [
                'post_id' => 1,
                'name' => 'Sara Ahmed',
                'email' => 'sara@example.com',
                'comment' => 'Can you write an article about how to upgrade from Laravel 9 to 10?',
                'is_approved' => false, // Pending approval
                'is_spam' => false,
                'ip_address' => '192.168.1.3',
                'created_at' => now()->subMinutes(30)
            ],
            [
                'post_id' => 2,
                'name' => 'PHP Developer',
                'email' => 'phpdev@example.com',
                'comment' => 'Excellent tips! I follow these practices in my projects.',
                'is_approved' => true,
                'is_spam' => false,
                'ip_address' => '192.168.1.4',
                'created_at' => now()->subDays(1)
            ],
            [
                'post_id' => 3,
                'name' => 'UI Designer',
                'email' => 'ui@example.com',
                'comment' => 'Vue.js is great for interfaces! Thanks for the article.',
                'is_approved' => true,
                'is_spam' => false,
                'ip_address' => '192.168.1.5',
                'created_at' => now()->subDays(2)
            ],
            [
                'post_id' => 4,
                'name' => 'Random User',
                'email' => 'spam@spam.com',
                'comment' => 'Buy my cheap products here: http://spam-site.com',
                'is_approved' => false,
                'is_spam' => true, // Spam comment
                'ip_address' => '192.168.1.6',
                'created_at' => now()->subHours(5)
            ]
        ];

        foreach ($comments as $commentData) {
            BlogComment::create($commentData);
        }

        // Update comments count in posts
        BlogPost::chunk(10, function ($posts) {
            foreach ($posts as $post) {
                $post->updateCommentsCount();
            }
        });

        $this->command->info('Blog data created successfully!');
        $this->command->info('- ' . BlogCategory::count() . ' categories');
        $this->command->info('- ' . BlogPost::count() . ' posts');
        $this->command->info('- ' . BlogComment::count() . ' comments');
    }
}