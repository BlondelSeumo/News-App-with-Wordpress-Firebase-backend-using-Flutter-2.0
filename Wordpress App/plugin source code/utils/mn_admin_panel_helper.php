<?php

add_action('wp_ajax_post_mn_admin_data', 'postMNAdminData');

/**************************************************************************************************************
 * Post Method Are Here
 */

function postMNAdminData()
{
    $status = false;
    $fields = [];
    if (isset($_POST['action'])
        && isset($_POST['_ajax_nonce'])
        && wp_verify_nonce($_POST['_ajax_nonce'], 'get_mn_admin_settings')
        && 'post_mn_admin_data' === $_POST['action']) {

        $fields = isset($_POST['fields']) ? $_POST['fields'] : [];

        $status = saveMNDashboardData($fields);

    }
    wp_send_json(['status' => $status, 'data' => []]);
}


function saveMNDashboardData($data)
{
    $status = false;
    
    $old_options = get_option('news_option');
    if ($data !== $old_options) {
        // update new settings
        $status = update_option('news_option', $data);
    } else if ($data === $old_options) {
        // for same data
        $status = true;
    }
    return $status;
}

function mnGetCategory()
{
    $args = array(
        'taxonomy' => 'category',
        'orderby' => 'name',
        'show_count' => 0,  // 1 for yes, 0 for no
        'pad_counts' => 0,  // 1 for yes, 0 for no
        'hierarchical' => 1,// 1 for yes, 0 for no
        'title_li' => '',
        'hide_empty' => 0,
        // 'parent' => 0    // need only parent category
    );
    $category = get_categories($args);
    $all_categories = [];
    if( !empty($category) ) {

        $all_categories = collect($category)->map(function ($res) {
            return ['value' => $res->term_id, 'text' => $res->name ];
        });
    }
    return $all_categories;
}