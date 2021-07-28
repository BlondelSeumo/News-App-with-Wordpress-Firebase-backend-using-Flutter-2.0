<?php 
require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
global $wpdb;
$charset_collate = $wpdb->get_charset_collate();


$table_name = $wpdb->prefix . 'news_favourite_blog'; // do not forget about tables prefix

$sql = "CREATE TABLE `{$wpdb->prefix}news_favourite_blog` (
    ID bigint(20) NOT NULL AUTO_INCREMENT,    
    user_id bigint(20) UNSIGNED NOT NULL,
    post_id bigint(20) UNSIGNED NOT NULL,
    created_at datetime  NULL,
    
    PRIMARY KEY  (ID)
  ) $charset_collate;";
  

  maybe_create_table($table_name,$sql);

$table_name = $wpdb->prefix . 'news_postview';

$sql = "CREATE TABLE $table_name (
    ID bigint(20) NOT NULL AUTO_INCREMENT,
    ip_address longtext NOT NULL,
    post_id bigint(20) NOT NULL,
    PRIMARY KEY  (ID)
) $charset_collate;";

maybe_create_table($table_name,$sql);

?>
