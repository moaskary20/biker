// Blog Image Refresh Script
document.addEventListener('DOMContentLoaded', function() {
    // Force refresh all blog images
    const blogImages = document.querySelectorAll('.blog-image, .img--40');
    
    blogImages.forEach(function(img) {
        if (img.src) {
            // Add timestamp to force refresh
            const url = new URL(img.src);
            url.searchParams.set('v', Date.now());
            img.src = url.toString();
        }
    });
    
    // Add event listener for form submissions
    const forms = document.querySelectorAll('form');
    forms.forEach(function(form) {
        form.addEventListener('submit', function() {
            // Clear image cache before submission
            const images = form.querySelectorAll('img');
            images.forEach(function(img) {
                if (img.src) {
                    const url = new URL(img.src);
                    url.searchParams.set('v', Date.now());
                    img.src = url.toString();
                }
            });
        });
    });
});
