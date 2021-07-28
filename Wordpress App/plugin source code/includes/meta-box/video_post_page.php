<?php
function mighty_videos_custom_post() {
    $labels = array(
        'name'               => _x( 'Videos', 'post type general name' ),
        'singular_name'      => _x( 'Video', 'post type singular name' ),
        'add_new'            => _x( 'Add New', 'video' ),
        'add_new_item'       => __( 'Add New video' ),
        'edit_item'          => __( 'Edit video' ),
        'new_item'           => __( 'New video' ),
        'all_items'          => __( 'All videos' ),
        'view_item'          => __( 'View video' ),
        'search_items'       => __( 'Search video' ),
        'not_found'          => __( 'No products found' ),
        'not_found_in_trash' => __( 'No products found in the Trash' ),
        'menu_name'          => 'Videos'
    );
    $args = array(
        'labels'        => $labels,
        'description'   => 'Holds our videos specific data',
        'public'        => true,
        'menu_position' => 5,
        'supports'      => array( 'title', 'thumbnail' ),
        'has_archive'   => true,
    );
    register_post_type( 'video', $args );
}

add_action( 'init', 'mighty_videos_custom_post' );

add_action( 'add_meta_boxes', 'mighty_url_meta_box' );
function mighty_url_meta_box() {
    add_meta_box(
        'mighty_url_box',
        __( 'Video details', 'myplugin_textdomain' ),
        'mighty_video_url_box_content',
        'video',
        'side',
        'high'
    );
}

function mighty_video_url_box_content( $post ) {
    wp_nonce_field( plugin_basename( __FILE__ ), 'video_url_box_content_nonce' );

    $video_url = get_post_meta( $post->ID,'video_url', true);
    $video_type = get_post_meta( $post->ID,'video_type', true);

    echo '<label for="mighty_video_type_box">Video type</label>';
    echo '<br>';
    echo '<select id="mighty_video_type_box" name="video_type" style="width:100%" required>';
    echo '<option> Select video type </option>';
    echo '<option value="youtube" ' . ($video_type == "youtube" ? 'selected="selected"' : '') . '>Youtube</option>';
    echo '<option value="iframe" ' . ($video_type == "iframe" ? 'selected="selected"' : '') . '>Iframe/embedded</option>';
    echo '<option value="custom_url" ' . ($video_type == "custom_url" ? 'selected="selected"' : '') . '>Custom URL</option>';
    echo '</select>';

    echo '<br>';
    echo '<br>';

    echo '<label for="mighty_url_box">Video URL</label>';
    echo '<input type="text" id="mighty_url_box" name="video_url" placeholder="Enter video URL" value="' . $video_url . '" style="width:100%" required />';
}

add_action( 'save_post', 'video_url_box_save' );
function video_url_box_save( $post_id ) {

    if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE )
        return;

    if ( isset($_POST['video_url_box_content_nonce']) && !wp_verify_nonce( $_POST['video_url_box_content_nonce'], plugin_basename( __FILE__ ) ) )
        return;

    if (isset($_POST['post_type']) && 'page' == $_POST['post_type'] ) {
        if ( !current_user_can( 'edit_page', $post_id ) )
            return;
    } else {
        if ( !current_user_can( 'edit_post', $post_id ) )
            return;
    }

    $product_price = isset($_POST['video_url']) ? $_POST['video_url'] : "";
    $video_type = isset($_POST['video_type']) ? $_POST['video_type'] : "";

    update_post_meta( $post_id, 'video_url', $product_price);
    update_post_meta( $post_id, 'video_type', $video_type);

}