<?php


function mnValidationToken () {
	$data = [
		'message' => 'Valid token',
        'status' => true,
	];
	$response = collect((new Jwt_Auth_Public('jwt-auth', '1.1.0'))->validate_token(false));
   
	if ($response->has('errors')) {
		$data['status'] = false;
		$data['message'] = isset(array_values($response['errors'])[0][0]) ? array_values($response['errors'])[0][0] : __("Authorization failed");
	}else {
        $data['user_id'] = $response['data']->user->id;
    }
	return $data;
}

function mnGenerateToken( $data ) {
	return wp_remote_post( get_home_url() . "/wp-json/jwt-auth/v1/token" , array(
		'body' => $data
	));
}

function mnValidateRequest($rules, $request, $message = [])
{
	$error_messages = [];
	$required_message = ' field is required';
	$email_message =  ' has invalid email address';

	if (count($rules)) {
		foreach ($rules as $key => $rule) {
			if (strpos($rule, '|') !== false) {
				$ruleArray = explode('|', $rule);
				foreach ($ruleArray as $r) {
					if ($r === 'required') {
						if (!isset($request[$key]) || $request[$key] === "" || $request[$key] === null) {
							$error_messages[] = isset($message[$key]) ? $message[$key] : str_replace('_', ' ', $key) . $required_message;
						}
					} elseif ($r === 'email') {
						if (isset($request[$key])) {
							if (!filter_var($request[$key], FILTER_VALIDATE_EMAIL) || !is_email($request[$key])) {
								$error_messages[] = isset($message[$key]) ? $message[$key] : str_replace('_', ' ', $key) . $email_message;
							}
						}
					}
				}
			} else {
				if ($rule === 'required') {
					if (!isset($request[$key]) || $request[$key] === "" || $request[$key] === null) {
						$error_messages[] = isset($message[$key]) ? $message[$key] : str_replace('_', ' ', $key) . $required_message;
					}
				} elseif ($rule === 'email') {
					if (isset($request[$key])) {
						if (!filter_var($request[$key], FILTER_VALIDATE_EMAIL) || !is_email($request[$key]) ) {
							$error_messages[] = isset($message[$key]) ? $message[$key] : str_replace('_', ' ', $key) . $email_message;
						}
					}
				}
			}

		}
	}

	return $error_messages;
}


function mnRecursiveSanitizeTextField($array)
{
	$filterParameters = [];
	foreach ($array as $key => $value) {

		if ($value === '') {
			$filterParameters[$key] = null;
		} else {
			if (is_array($value)) {
				$filterParameters[$key] = mnRecursiveSanitizeTextField($value);
			} else {
				if (preg_match("/<[^<]+>/", $value, $m) !== 0) {
					$filterParameters[$key] = $value;
				} else {
					$filterParameters[$key] = sanitize_text_field($value);
				}
			}
		}

	}

	return $filterParameters;
}

function mnGetErrorMessage ($response) {
	return isset(array_values($response->errors)[0][0]) ? array_values($response->errors)[0][0] : __("Internal server error");
}

function mnGenerateString($length_of_string = 10)
{
	// String of all alphanumeric character
	$str_result = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
	return substr(str_shuffle($str_result),0, $length_of_string);
}

if(!function_exists('comman_message_response')){
	function comman_message_response( $message, $status_code = 200)
	{
		$response = new WP_REST_Response(array(
				"message" => $message
			)
		);
		$response->set_status($status_code);
		return $response;
	}
}

if(!function_exists('comman_custom_response')){
	function comman_custom_response( $res, $status_code = 200 )
	{
		$response = new WP_REST_Response($res);
		$response->set_status($status_code);
		return $response;
	}
}

if(!function_exists('comman_list_response')){
    function comman_list_response( $data )
    {
        $response = new WP_REST_Response(array(
            "data" => $data
        ));

        $response->set_status(200);
        return $response;
    }
}

function get_taxonomy_terms_helper( $list, $type , $taxonomy = 'cat' ) {
	$terms = array();

	foreach ( wp_get_object_terms( $list->ID, $type.'_'. $taxonomy ) as $term ) {
		$terms[] = array(
			'id'   => $term->term_id,
			'name' => $term->name,
			'slug' => $term->slug,
		);
	}

	return $terms;
}

function mighty_post_args($params = null, $filter = null, $post_in = null) {

    $args['post_type'] = 'post';
    $args['post_status'] = 'publish';
    $args['posts_per_page'] = 5;
    $args['paged'] = 1;

    $news_option = get_option('news_option');

    $ignore_sticky_post = isset($news_option['disable_sticky_post']) && $news_option['disable_sticky_post'] == false ? false : true;
    
    $args['ignore_sticky_posts'] = $ignore_sticky_post;
    if ($post_in) {
        $args['post__in'] = $post_in;
    }


    if ($params) {
        if (!empty($params['posts_per_page']) && isset($params['posts_per_page'])) {
            $args['posts_per_page'] = $params['posts_per_page'];
        }
        if (!empty($params['paged']) && isset($params['paged'])) {
            $args['paged'] = $params['paged'];
        }
        if (!empty($params['category']) && isset($params['category'])) {
            $args['category'] = $params['category'];
        }
        if (!empty($params['text']) && isset($params['text'])) {
            $args['s'] = $params['text'];
        }
        if (!empty($params['subcategory']) && isset($params['subcategory'])) {
            $args['category'] = $params['subcategory'];
        }

    }
    if( $filter != 'story' ){
        $args['meta_query'] = array(
            'relation' => 'OR',
            array(
                'key' => 'mn_is_story',
                'value' => 0,
                'compare' => '=='
            ),
            array(
                'key'     => 'mn_is_story',
                'compare' => 'NOT EXISTS',
            ),
        );
    }

    if ($filter === 'recent') {
        $args['cat'] = ( isset($news_option['selected_category']) && !empty($news_option['selected_category']) ) ? implode(',',$news_option['selected_category']) : "";
        $args['order'] = 'DESC';
        $args['orderby'] = 'post_date';
        
    }
    if ($filter === 'feature') {
        $value = rwmb_meta('mn_is_featured');
        $args['meta_query'] = array(
            array(
                'key' => 'mn_is_featured',
                'value' => true,
                'compare' => '=='
            )
        );
    }
    if ($filter === 'story') {
        // $value = rwmb_meta('mn_is_story');
        
        $args['meta_query'] = array(
            array(
                'key' => 'mn_is_story',
                'value' => true,
                'compare' => '=='
            )
        );
        $args['date_query'] = array(
            array(
                'after' => '24 hours ago'
            )
        );
    }

    if ($filter == 'by_category') {
        if ($params) {
            if (!empty($params['category']) && isset($params['category'])) {
                $args['cat'] = $params['category'];
            }
            if (!empty($params['subcategory']) && isset($params['subcategory'])) {
                $args['cat'] = $params['subcategory'];
            }
        }
    }

    return $args;
}

function mighty_get_blog_data($wp_query = null, $user_id = null)
{

    $temp = array();
    global $post;
    global $wpdb;

	$image = wp_get_attachment_image_src(get_post_thumbnail_id($post->ID), [300, 300]);	
	$full_image = wp_get_attachment_image_src(get_post_thumbnail_id($post->ID), "full");	
    $profile_image = get_user_meta( $post->post_author, 'mighty_profile_image' , true);
    // $profile_image = get_user_meta( $post->post_author, 'news_profile_image', true );
    $category = get_the_category($post->ID);
    if( !empty($category) && count($category) > 0 ) {
        $category = collect($category)->map(function ($category) {
            $category->image = (z_taxonomy_image_url($category->term_id)) ? z_taxonomy_image_url($category->term_id) : null;
            return $category;
        });
    }
    $temp = [
        'ID'                => $post->ID,
        'image'             => !empty($image) ? $image[0] : null,
        'full_image'        => !empty($full_image) ? $full_image[0] : null,
        'post_title'        => get_the_title(),
        'post_content'      => esc_html(get_the_content()),
        'post_excerpt'      => esc_html(get_the_excerpt()),
        'post_date'         => $post->post_date,
        'post_date_gmt'     => $post->post_date_gmt,
        'readable_date'     => get_the_date(),
        'share_url'         => get_the_permalink(),
        'human_time_diff'   => human_time_diff(get_the_time('U'), current_time('timestamp')) . ' ' . __('ago'),
        'no_of_comments'    => get_comments_number(),
        'no_of_comments_text'   => get_comments_number_text( false, false, false, $post->ID),
        'is_fav'            => user_favourite_blog ( $post->ID , $user_id  ),
        'post_author_name'  => get_the_author( 'display_name' , $post->post_author ),
        'post_author_image' => ( $profile_image ) ? $profile_image : null,
        'post_view'         => (int) get_post_meta( $post->ID, 'post_view', true ),
        'is_story'         =>  (bool) rwmb_meta('mn_is_story'),
        'category' 		    => $category,
    ];
    return $temp;
}

function user_favourite_blog ( $post_id , $user_id  ){
    global $wpdb;
    $table_name = $wpdb->prefix.'news_favourite_blog';
    if ( $user_id != null ) {
        $favourite_blog = $wpdb->get_row("SELECT * FROM {$table_name} WHERE `user_id`=" . $user_id . " AND `post_id` =" . $post_id . "", OBJECT);
        if (empty($favourite_blog)) {
            return false;
        }
        return true;
    } else {
        return false;
    }
}
function mightynews_title_filter( $where, $wp_query ){
    global $wpdb;
    if( $search_term = $wp_query->get( 'mightynews_title_filter' ) ) :
        $search_term = $wpdb->esc_like( $search_term );
        $search_term = ' \'%' . $search_term . '%\'';
        $title_filter_relation = ( strtoupper( $wp_query->get( 'title_filter_relation' ) ) == 'OR' ? 'OR' : 'AND' );
        $where .= ' '.$title_filter_relation.' ' . $wpdb->posts . '.post_title LIKE ' . $search_term;
    endif;
    return $where;
}

add_filter( 'posts_where', 'mightynews_title_filter', 10, 2 );

function mighty_post_view ( $post_id ) {
    global $wpdb;

    $ipaddress = $_SERVER['REMOTE_ADDR'] ;
    
    $table_name = $wpdb->prefix . 'news_postview';
    
    $already_exist = $wpdb->get_row("SELECT * FROM $table_name WHERE ip_address = '{$ipaddress}' AND post_id = {$post_id} ",OBJECT);

    if ( gettype($already_exist) !== 'object') {
        $wpdb->insert($table_name, array(
            'ip_address' => $ipaddress,
            'post_id' => $post_id
        ));

        set_newsview($post_id);
    }

    $post_count = (int) get_post_meta( $post_id, 'post_view', true );
       
    return (int) $post_count;
}

function user_post_view_count($post_id)
{
    global $wpdb;

    $ipaddress = $_SERVER['REMOTE_ADDR'] ;
    
    $table_name = $wpdb->prefix . 'news_postview';
    
    $already_exist = $wpdb->get_row("SELECT * FROM $table_name WHERE ip_address = '{$ipaddress}' AND post_id = {$post_id} ",OBJECT);
    
    if ( gettype($already_exist) !== 'object') {
        /*$wpdb->insert($table_name, array(
            'ip_address' => $ipaddress,
            'post_id' => $post_id
        ));*/

    }
    set_newsview($post_id);
}

function set_newsview($post_id) {
    $key = 'post_view';
    
    $count = (int) get_post_meta( $post_id, $key, true );
    $count++;
    update_post_meta( $post_id, $key, $count );
}