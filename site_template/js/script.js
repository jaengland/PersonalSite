$(document).ready(function() {
    $("#home-link").click(function() {
        $("#content").fadeOut('slow', function() {
            $("#content").load("index.html #content", function() {
                $("#content").fadeIn('slow');
            });
        });
        return false;
    });

    $("#projects-link").click(function() {
        $("#content").fadeOut('slow', function() {
            $("#content").load("projects.html", function() {
                $("#content").fadeIn('slow');
            });
        });
        return false;
    });
});
