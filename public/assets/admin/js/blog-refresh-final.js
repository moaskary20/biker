// Blog Image Refresh Script - Final Version
document.addEventListener('DOMContentLoaded', function() {
    console.log('Blog Image Refresh Script - Final Version Loaded');
    
    // Force refresh all blog images
    function refreshBlogImages() {
        const blogImages = document.querySelectorAll('.blog-image, .img--40, .img-thumbnail');
        
        blogImages.forEach(function(img) {
            if (img.src && img.src.includes('blog-image')) {
                // Add timestamp to force refresh
                const url = new URL(img.src);
                url.searchParams.set('v', Date.now());
                img.src = url.toString();
                console.log('Refreshed image:', img.src);
            }
        });
    }
    
    // Initial refresh
    refreshBlogImages();
    
    // Refresh every 3 seconds
    setInterval(refreshBlogImages, 3000);
    
    // Add event listener for form submissions
    const forms = document.querySelectorAll('form');
    forms.forEach(function(form) {
        form.addEventListener('submit', function() {
            console.log('Form submitted, refreshing images...');
            setTimeout(refreshBlogImages, 1000);
        });
    });
    
    // Add event listener for file input changes
    const fileInputs = document.querySelectorAll('input[type="file"]');
    fileInputs.forEach(function(input) {
        input.addEventListener('change', function() {
            console.log('File input changed, refreshing images...');
            setTimeout(refreshBlogImages, 500);
        });
    });
    
    // Add event listener for page navigation
    window.addEventListener('popstate', function() {
        setTimeout(refreshBlogImages, 500);
    });
    
    // Add event listener for hash changes
    window.addEventListener('hashchange', function() {
        setTimeout(refreshBlogImages, 500);
    });
    
    // Force refresh on page focus
    window.addEventListener('focus', function() {
        refreshBlogImages();
    });
});
