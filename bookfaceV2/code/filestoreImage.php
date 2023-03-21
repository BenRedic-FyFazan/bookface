<?php

$image = $_GET['image'];
include_once "config.php";

if ( $memcache_enabled == 1 and $memcache_enabled_pictures== 1) {
    $memcache_picture_duration = 3600;
    $memcache = new Memcache();
    $memcache->addServer($memcache_server, "11211");
}

if ($memcache) {
    $key = "picture_" . $image;
    $picture_of_user = $memcache->get($key);

    if ( !$picture_of_user) {
        $picture_of_user = file_get_contents('/images/' . $image);
    }

    if ($picture_of_user) {
        $memcache->set($key, $picture_of_user,0,$memcache_picture_duration);
    } else {
        $picture_of_user = NULL;
        // ERRORMESSAGE -> no image found in memcache or on filesystem
    }

} else {
    $picture_of_user = file_get_contents('/images/' . $image);
}

echo $picture_of_user;


