<?php


namespace Includes\Controllers\Api;
use WP_REST_Response;
use WP_REST_Server;
use WP_Query;
use WP_Post;
use Wp_User;
use Includes\baseClasses\MNBase;

class MNNewsController extends MNBase {

    public $module = 'mighty';

	public $nameSpace;

	function __construct() {

        $this->nameSpace = MIGHTYNEWS_API_NAMESPACE;
        
        add_action( 'rest_api_init', function () {

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/change-password', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_change_password' ],
				'permission_callback' => '__return_true'
			));

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/forgot-password', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_forgot_password' ],
				'permission_callback' => '__return_true'
            ));
            
            register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/update-profile', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_update_profile' ],
				'permission_callback' => '__return_true'
			));

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-video-list', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_get_video_list' ],
				'permission_callback' => '__return_true'
			));


			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-dashboard', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_get_dashboard' ],
				'permission_callback' => '__return_true'
			));

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-blog-by-filter', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_get_blog_by_filter' ],
				'permission_callback' => '__return_true'
			));

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/post-comment', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_post_comment' ],
				'permission_callback' => '__return_true'
			));

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/add-fav-list', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_add_favourite_blog' ],
				'permission_callback' => '__return_true'
			));

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-fav-list', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_favourite_blog_list' ],
				'permission_callback' => '__return_true'
			));
			
			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/delete-fav-list', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_delete_favourite_blog' ],
				'permission_callback' => '__return_true'
			));
			
			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-post-details', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_get_post_details' ],
				'permission_callback' => '__return_true'
			));

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/get-category', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_get_category' ],
				'permission_callback' => '__return_true'
			));

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/view-profile', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_view_profile' ],
				'permission_callback' => '__return_true',
			) );

			register_rest_route( $this->nameSpace . '/api/v1/' . $this->module, '/social_login', array(
				'methods'             => WP_REST_Server::ALLMETHODS,
				'callback'            => [ $this, 'mighty_get_customer_by_social' ],
				'permission_callback' => '__return_true'
            ));
        });
    }

    public function mighty_change_password($request) {

		$data = mnValidationToken();

		if (!$data['status']) {
			return comman_custom_response($data,401);
		}

		$parameters = $request->get_params();

		$userdata = get_user_by('ID', $data['user_id']);
		
		if ($userdata == null) {
			
			if ($userdata == null) {
				$message = __('User not found');
				return comman_message_response($message,422);
			}
		}

		$status_code = 200;

		if (wp_check_password($parameters['old_password'], $userdata->data->user_pass)){
			wp_set_password($parameters['new_password'], $userdata->ID);
			$message = __("Password has been changed successfully");
		}else {
			$status_code = 422;
			$message = __("Old password is invalid");
		}
		return comman_message_response($message,$status_code);
	}

	public function mighty_forgot_password($request) {
		$parameters = $request->get_params();
		$email = $parameters['email'];
		
		$user = get_user_by('email', $email);
		$message = null;
		$status_code = null;
		
		if($user) {      

			$title = 'New Password';
            $password = mnGenerateString();
            $message = '<label><b>Hello,</b></label>';
            $message.= '<p>Your recently requested to reset your password. Here is the new password for your App</p>';
            $message.='<p><b>New Password </b> : '.$password.'</p>';
            $message.='<p>Thanks,</p>';

            $headers = "MIME-Version: 1.0" . "\r\n";
            $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
			$is_sent_wp_mail = wp_mail($email,$title,$message,$headers);

            if($is_sent_wp_mail) {
				wp_set_password( $password, $user->ID);
				$message = __('Password has been sent successfully to your email address.');
				$status_code = 200;
			} elseif (mail( $email, $title, $message, $headers )) {
				wp_set_password( $password, $user->ID);
				$message = __('Password has been sent successfully to your email address.');
				$status_code = 200;
			} else {
				$message = __('Email not sent');
				$status_code = 422;
			}
		} else {
			$message = __('User not found with this email address');
			$status_code = 422;
		}
		return comman_message_response($message,$status_code);
    }
    
    public function mighty_update_profile($request) {
		$data = mnValidationToken();

		if (!$data['status']) {
			return comman_custom_response($data,401);
		}

		$parameters = $request->get_params();
		$userdata = get_user_by('ID', $data['user_id']);
		
		if ($userdata == null) {
			
			if ($userdata == null) {
				$message = __('User not found');
				return comman_message_response($message,422);
			}
		}
		$message = __("Profile has been updated successfully");
		$data = array();
		wp_update_user([
			'ID' => $userdata->ID,
			'first_name' => $parameters['first_name'],
			'last_name' => $parameters['last_name']
		]);
		update_user_meta( $userdata->ID , 'my_topics' , $parameters['my_topics']);
		update_user_meta( $userdata->ID , 'my_preference' , json_decode( $parameters['my_preference']));
		$data = [
			'first_name' => get_user_meta($userdata->ID , 'first_name' ,true),
			'last_name' => get_user_meta($userdata->ID , 'last_name' ,true),
			'my_topics' => json_decode(get_user_meta( $userdata->ID , 'my_topics' ,true)),
			'my_preference' => get_user_meta( $userdata->ID , 'my_preference',true),
		];
		if( isset($_FILES['profile_image']) && $_FILES['profile_image'] != null ){

			$profile_image = $_FILES['profile_image']; 
			/*$type      =  $profile_image['type'];

            $extension = pathinfo($profile_image['name'], PATHINFO_EXTENSION);

            // Upload dir.
            $upload_dir  = wp_upload_dir();
            $upload_path = str_replace( '/', DIRECTORY_SEPARATOR, $upload_dir['path'] ) . DIRECTORY_SEPARATOR;

			$upload_file = move_uploaded_file( $profile_image["tmp_name"],$upload_path.$profile_image["name"] );
		
			$attachment = array(
				'post_mime_type' => $extension,
                'post_title'     => preg_replace( '/\.[^.]+$/', '', $profile_image["name"] ),
                'post_content'   => '',
                'post_status'    => 'inherit',
                'guid'           => $upload_dir['url'] . '/' . $profile_image["name"]
			);
		
			$attach_id = wp_insert_attachment( $attachment, $upload_dir['path'] . '/' . $profile_image["name"] );
		
			// Regenerate Thumbnail
			global $wpdb;
			$images = $wpdb->get_results( "SELECT ID FROM $wpdb->posts WHERE post_type = 'attachment' AND post_mime_type LIKE 'image/%' AND ID ='$attach_id'" );
		
			foreach ( $images as $image ) {
				$id = $image->ID;
				$fullsizepath = get_attached_file( $id );
		
				if ( false === $fullsizepath || !file_exists($fullsizepath) )
					return;

			}*/
			$attach_id = media_handle_upload( 'profile_image', 0 );
			$url = wp_get_attachment_url( $attach_id );
	
			$update = update_user_meta( $userdata->ID, 'mighty_profile_image', $url );
			update_user_meta( $userdata->ID, 'news_profile_image', $url );

			if(!is_wp_error($update))
			{
				$img = get_user_meta( $userdata->ID, 'mighty_profile_image' , true ) ;  
				$data['profile_image'] = $img;
				$data['news_profile_image'] = $img;
			}
			
		}
		$data['message'] = $message;
		
		return comman_custom_response($data);
	}

	public function  mighty_get_video_list($request) {
		$parameters = $request->get_params();
	
		$args = [
			'post_type' 		=> 'video',
			'post_status' 		=> 'publish',
			'posts_per_page' 	=> (!empty($parameters['posts_per_page']) && isset($parameters['posts_per_page'])) ? $parameters['posts_per_page'] : 10,
			'paged' 			=> (!empty($parameters['paged']) && isset($parameters['paged'])) ? $parameters['paged'] : 1,
			's' 				=> (isset($parameters['search']) && $parameters['search'] != '' ) ? $parameters['search'] : ''
		];

		$video_list = [];

    	$posts = get_posts($args);

		if (count($posts)) {
			foreach ($posts as $post) {

				$full_image = wp_get_attachment_image_src(get_post_thumbnail_id($post), "medium");

				array_push($video_list, [
					'id' => $post->ID,
					'title' => $post->post_title,
					'video_type' => get_post_meta($post->ID, 'video_type', true),
					'video_url' => get_post_meta($post->ID, 'video_url', true),
					'image_url' => !empty($full_image) ? $full_image[0] : null,
					'created_at' => human_time_diff( strtotime( $post->post_date ) )
				]);
			}
		}

		return comman_custom_response($video_list);
	}

	public function mighty_get_dashboard($request) {
	
		global $post;
		global $wpdb;

		$parameters = $request->get_params();

		$data = mnValidationToken();
		$user_id = null;
		if ($data['status']) {
			$user_id = $data['user_id'];
		}
		
		$masterarray = array();
		$array = array();
		$dashborad = array();
		$social = array();
		$testimonial = array();
		$news_option = get_option('news_option');
	
		if (isset($news_option['whatsapp'])) {
			$social['whatsapp'] = $news_option['whatsapp'];
		} else {
			$social['whatsapp'] = null;
		}
	
		if (isset($news_option['disable_ad'])) {
			$social['disable_ad'] = (bool) $news_option['disable_ad'];
		} else {
			$social['disable_ad'] = null;
		}

		if (isset($news_option['disable_location'])) {
			$social['disable_location'] = (bool) $news_option['disable_location'];
		} else {
			$social['disable_location'] = null;
		}

		if (isset($news_option['disable_twitter'])) {
			$social['disable_twitter'] = (bool) $news_option['disable_twitter'];
		} else {
			$social['disable_twitter'] = null;
		}

		if (isset($news_option['disable_cryptocurrency'])) {
			$social['disable_cryptocurrency'] = (bool) $news_option['disable_cryptocurrency'];
		} else {
			$social['disable_cryptocurrency'] = null;
		}

		if (isset($news_option['disable_headline'])) {
			$social['disable_headline'] = (bool) $news_option['disable_headline'];
		} else {
			$social['disable_headline'] = null;
		}
		
		if (isset($news_option['disable_story'])) {
			$social['disable_story'] = (bool) $news_option['disable_story'];
		} else {
			$social['disable_story'] = null;
		}
		
		if (isset($news_option['disable_quickread'])) {
			$social['disable_quickread'] = (bool) $news_option['disable_quickread'];
		} else {
			$social['disable_quickread'] = null;
		}

		if (isset($news_option['facebook'])) {
			$social['facebook'] = $news_option['facebook'];
		} else {
			$social['facebook'] = null;
		}
	
		if (isset($news_option['twitter'])) {
			$social['twitter'] = $news_option['twitter'];
		} else {
			$social['twitter'] = null;
		}
	
		if (isset($news_option['instagram'])) {
			$social['instagram'] = $news_option['instagram'];
		} else {
			$social['instagram'] = null;
		}
	
	
		if (isset($news_option['contact'])) {
			$social['contact'] = $news_option['contact'];
		} else {
			$social['contact'] = null;
		}
	
		if (isset($news_option['privacy_policy'])) {
			$social['privacy_policy'] = $news_option['privacy_policy'];
		} else {
			$social['privacy_policy'] = null;
		}
	
		if (isset($news_option['copyright_text'])) {
			$social['copyright_text'] = esc_html($news_option['copyright_text']);
		} else {
			$social['copyright_text'] = null;
		}
	
		if (isset($news_option['term_condition'])) {
			$social['term_condition'] = esc_html($news_option['term_condition']);
		} else {
			$social['term_condition'] = null;
		}
	
		$dashborad['social_link'] = $social;
		/*
			Recent Post
		*/
	
		$masterarray = array();
	
		$wp_query = new WP_Query(mighty_post_args($parameters, 'recent'));
	
		global $post;
		if ($wp_query->have_posts()) {
			while ($wp_query->have_posts()) {
				$wp_query->the_post();
	
				array_push($masterarray, mighty_get_blog_data($wp_query, $user_id));
	
			}
			$dashborad['recent_num_pages'] = $wp_query->max_num_pages;
			$dashborad['recent_post'] = $masterarray;
		} else {
			$dashborad['recent_post'] = $masterarray;
		}
	
		$masterarray = array();
	
		$wp_query = new WP_Query(mighty_post_args($parameters, 'feature'));
	
		global $post;
		if ($wp_query->have_posts()) {
			while ($wp_query->have_posts()) {
				$wp_query->the_post();
				array_push($masterarray, mighty_get_blog_data($wp_query, $user_id));
			}
			$dashborad['feature_num_pages'] = $wp_query->max_num_pages;
			$dashborad['feature_post'] = $masterarray;
		} else {
			$dashborad['feature_post'] = $masterarray;
		}

		$video_list = [];

		$video_args = [
			'post_type' 		=> 'video',
			'post_status' 		=> 'publish',
			'posts_per_page' 	=> (!empty($parameters['posts_per_page']) && isset($parameters['posts_per_page'])) ? $parameters['posts_per_page'] : 5,
			'paged' 			=> (!empty($parameters['paged']) && isset($parameters['paged'])) ? $parameters['paged'] : 1,
		];
		
    	$video_posts = get_posts($video_args);

		if (count($video_posts)) {
			foreach ($video_posts as $post) {

				$full_image = wp_get_attachment_image_src(get_post_thumbnail_id($post), "medium");

				array_push($video_list, [
					'id' => $post->ID,
					'title' => $post->post_title,
					'video_type' => get_post_meta($post->ID, 'video_type', true),
					'video_url' => get_post_meta($post->ID, 'video_url', true),
					'image_url' => !empty($full_image) ? $full_image[0] : null,
					'created_at' => human_time_diff( strtotime( $post->post_date ) )
				]);
			}
		}
		$dashborad['videos'] = $video_list;

		$masterarray = array();
	
		$wp_query = new WP_Query(mighty_post_args($parameters, 'story'));
	
		global $post;
		if ($wp_query->have_posts()) {
			while ($wp_query->have_posts()) {
				$wp_query->the_post();
				array_push($masterarray, mighty_get_blog_data($wp_query, $user_id));
			}
			$dashborad['story_num_pages'] = $wp_query->max_num_pages;
			$dashborad['story_post'] = $masterarray;
		} else {
			$dashborad['story_post'] = $masterarray;
		}

		return comman_custom_response($dashborad);
	
	}

	public function mighty_get_blog_by_filter($request) {
		global $post;
		global $wpdb;

		$parameters = $request->get_params();
		$data = mnValidationToken();

		$user_id = null;
		if ($data['status']) {
			$user_id = $data['user_id'];
		}


		$masterarray = array();
		$dashborad = array();

		if (isset($parameters['filter']) && !empty($parameters['filter'])) {
			$filter = $parameters['filter'];
		} else {
			$filter = 'by_category';
		}

		$args = mighty_post_args($parameters, $filter);

		if ( $filter == 'suggested' ) {
			if ( $user_id != null ) {
				$topics_category = ( get_user_meta( $user_id , 'my_topics' ,true) != null ) ? json_decode(get_user_meta( $user_id , 'my_topics' ,true)) : null;

				if( !empty($topics_category) && $topics_category != null  ) {
					$args['cat'] = implode(',',$topics_category);
				}
			}
		}
		$wp_query = new WP_Query( $args );
		
		if ($wp_query->have_posts()) {
			while ($wp_query->have_posts()) {
				$wp_query->the_post();

				array_push($masterarray, mighty_get_blog_data($wp_query, $user_id));

			}
			$dashborad['num_pages'] = $wp_query->max_num_pages;
			$dashborad['posts'] = $masterarray;
		} else {
			$dashborad['num_pages'] = $wp_query->max_num_pages;
			$dashborad['posts'] = $masterarray;
			

		}

		return comman_custom_response($dashborad);
	}

	public function mighty_post_comment($request) {
		$data = mnValidationToken();

		if (!$data['status']) {
			return comman_custom_response($data,401);
		}

		$parameters = $request->get_params();

		$userdata = get_user_by('ID', $data['user_id']);
		
		if ($userdata == null) {
			
			if ($userdata == null) {
				$message = __('User not found');
				return comman_message_response($message,422);
			}
		}


		if (!get_post($parameters['comment_post_ID'])) {
			return comman_message_response(__('Post Not Found'),422);
		}
	
		$status_code = 200;
		$args['user_id'] = $userdata->ID;
		$args['comment_post_ID'] = $parameters['comment_post_ID'];
		$args['comment_author'] = $userdata->display_name;
		$args['comment_author_email'] = $userdata->user_email;
		$args['comment_content'] = $parameters['comment_content'];

		if (wp_insert_comment($args)) {
			$message	= __("Comment Posted Sucessfully");
		} else {
			$message = __('Comment Not Submiited');
			$status_code = 422;
		}

		return comman_message_response($message , $status_code);
	}

	public function mighty_add_favourite_blog($request) {
		global $wpdb;
		$table_name = $wpdb->prefix.'news_favourite_blog';
		
		$data = mnValidationToken();

		if (!$data['status']) {
			return comman_custom_response($data,401);
		}

		$parameters = $request->get_params();
		
		$post_id = $parameters['post_id'];
		$user_id = $data['user_id'];
	
		$post = get_post($post_id);
	
		if($post == null){
			return comman_message_response( __('Not found') , 422 );
		}

		$favourite_blog = user_favourite_blog($post_id , $user_id);

		if(!$favourite_blog) {
			$insdata = array (
				"user_id"		=> $user_id,
				"created_at"	=> current_time('mysql'),
				"post_id" 		=> $post_id
			);
		
			$wpdb->insert($table_name, $insdata);			
			$isFav = true;
			$message = __('Blog Succesfully Added To Favourite List.');
		} else {
			$isFav = false;
			$message = __('Blog Already in Favourite List.');
		}
		$resArray = array('is_fav' => $isFav, 'message' => $message);
		return comman_custom_response( $resArray );
	}

	public function mighty_favourite_blog_list($request) {

		global $wpdb;
		$table_name = $wpdb->prefix.'news_favourite_blog';

		$data = mnValidationToken();

		if (!$data['status']) {
			return comman_custom_response($data,401);
		}

		$parameters = $request->get_params();

		$userdata = get_user_by('ID', $data['user_id']);
		
		if ($userdata == null) {
			
			if ($userdata == null) {
				$message = __('User not found');
				return comman_message_response($message,422);
			}
		}
		$user_id = $userdata->ID;

		$favourite_blog_list = $wpdb->get_results("SELECT * FROM {$table_name} WHERE `user_id`=" . $user_id  , OBJECT);

		if( empty ($favourite_blog_list)) {
			return comman_message_response( __('No Blog In Favourite List') );
		}

		$post_ids = collect($favourite_blog_list)->pluck('post_id')->toArray();

		$masterarray = [];
		$dashboard = [];

		$wp_query = new WP_Query(mighty_post_args($parameters, '', $post_ids));

		if ($wp_query->have_posts()) {
			while ($wp_query->have_posts()) {
				$wp_query->the_post();
				$masterarray[] = mighty_get_blog_data($wp_query, $user_id);
			}
			$dashborad['num_pages'] = $wp_query->max_num_pages;
			$dashborad['posts'] = $masterarray;
		} else {
			return comman_message_response(__('No Favorite Blog Found'));
		}
		return comman_custom_response($dashborad);

	}

	public function mighty_delete_favourite_blog($request) {
		global $wpdb;
		$table_name = $wpdb->prefix.'news_favourite_blog';
		
		$data = mnValidationToken();

		if (!$data['status']) {
			return comman_custom_response($data,401);
		}

		$parameters = $request->get_params();
		
		$post_id = $parameters['post_id'];
		$user_id = $data['user_id'];
		$message = __('Blog Deleted From Favourite List.');
		$favourite_blog = user_favourite_blog($post_id , $user_id);

		if(!$favourite_blog) {
			$message = __('Blog Not Found In Favourite List.');
		}

		$favourite_blog = $wpdb->delete( $table_name , array ('user_id' => $user_id, 'post_id' => $post_id) );

		return comman_message_response( $message );
	}

	public function mighty_get_post_details ($request) {
		global $post;
		global $wpdb;

		$parameters = $request->get_params();

		$data = mnValidationToken();
		$user_id = null;
		if ($data['status']) {
			$user_id = $data['user_id'];
		}
		$post_data = WP_Post::get_instance($parameters['post_id']);

		if (empty($post_data)) {
			return comman_custom_response( (object) array());
		}
		$post_author = get_user_by('ID', $post_data->post_author);

		$post_data->post_author_name	= ($post_author !== null) ? $post_author->data->display_name : '' ;

		$profile_image = get_user_meta( $post_data->post_author, 'mighty_profile_image', true);
		// $profile_image = get_user_meta( $post_data->post_author, 'news_profile_image' , true );
		$post_data->post_author_image = ( $profile_image ) ? $profile_image : null ;

		$image 				= wp_get_attachment_image_src( get_post_thumbnail_id( $post_data->ID  ), [300, 300] );
		$post_data->image 	= !empty($image) ? $image[0] : null;	

		$full_image 			= wp_get_attachment_image_src( get_post_thumbnail_id( $post_data->ID  ), "full" );
		$post_data->full_image 		= !empty($full_image) ? $full_image[0] : null;	
		$post_data->readable_date 	= get_the_date('', $post_data);
		$post_data->no_of_comments 	= get_comments_number($post_data->ID);
		$post_data->no_of_comments_text	= get_comments_number_text( false, false, false, $post_data->ID);
		$post_data->share_url 		= get_the_permalink($post_data->ID);
		$post_data->is_fav 			= user_favourite_blog($post_data->ID,$user_id);
		$post_data->category 		= get_the_category($post_data->ID);
		$post_data->human_time_diff = human_time_diff(get_the_time('U',$post_data), current_time('timestamp')) . ' ' . __('ago');
		$post_data->is_story		= (bool) rwmb_meta('mn_is_story','',$post_data->ID);
		$categories = wp_get_post_categories($post_data->ID);
		
		$masterarray = [];
		if ( !empty($categories) ) {
			
			$news_option = get_option('news_option');
    		$ignore_sticky_post = isset($news_option['disable_sticky_post']) && $news_option['disable_sticky_post'] == false ? false : true;
			$cargs = [
				'post_type' 	=> 'post',
				'post_status' 	=> 'publish',
				'posts_per_page'=> 10,
				'paged' 		=> 1,
				'order'			=> 'DESC',
				'orderby'		=> 'post_date',
				'cat'			=> implode(',',$categories),
				'post__not_in'	=> array($post_data->ID),
				'ignore_sticky_posts' => $ignore_sticky_post,
				'meta_query'	=> array(
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
				),
			];

			$wp_query = new WP_Query ( $cargs );
			
			if ($wp_query->have_posts()) {
				while ($wp_query->have_posts()) {
					$wp_query->the_post();
					array_push($masterarray, mighty_get_blog_data($wp_query, $user_id));
				}
			}
		}

		$count = mighty_post_view( $post_data->ID );
		
		// update_post_meta ( $post_data->ID , 'post_view' , $count + 1 );
		$post_data->post_view = $count;// mighty_post_view( $post_data->ID );
		$post_data->related_news = $masterarray;
		return comman_custom_response($post_data);
	}

	public function mighty_get_category ($request) {

		$parameters = $request->get_params();
		$taxonomy     = 'category';
		$orderby      = 'name';
		$show_count   = 0;      // 1 for yes, 0 for no
		$pad_counts   = 0;      // 1 for yes, 0 for no
		$hierarchical = 1;      // 1 for yes, 0 for no
		$title        = '';
		$empty        = 0;
		$parent = !empty($parameters['parent']) && $parameters['parent'] != null ? $parameters['parent'] : 0 ;
		$args = array(
			'taxonomy' => $taxonomy,
			'orderby' => $orderby,
			'show_count' => $show_count,
			'pad_counts' => $pad_counts,
			'hierarchical' => $hierarchical,
			'title_li' => $title,
			'hide_empty' => $empty,
			'category_parent' => 0,
			'parent' => $parent
		);
	
		$category = get_categories($args);
		$all_categories = [];
		if( !empty($category) ) {

			$all_categories = collect($category)->map(function ($category) {
				$category->image = (z_taxonomy_image_url($category->term_id)) ? z_taxonomy_image_url($category->term_id) : null;
				return $category;
			});
		}

		return comman_custom_response( $all_categories );
	
	}

	public function mighty_view_profile ( $request) {
		$data = mnValidationToken();

		if (!$data['status']) {
			return comman_custom_response($data,401);
		}

		$user_id = $data['user_id'];

		$img       = get_user_meta( $user_id, 'mighty_profile_image', true );
		$user_info = get_userdata( $user_id );

		$response['first_name'] = $user_info->first_name;
		$response['last_name']  = $user_info->last_name;
		$response['user_id']    = $user_info->ID;
		$response['my_topics'] 	= ( get_user_meta( $user_id , 'my_topics' ,true) != null ) ? json_decode(get_user_meta( $user_id , 'my_topics' ,true)) : [];
		$response['my_preference'] 	= ( get_user_meta( $user_id , 'my_preference' ,true) != null ) ? get_user_meta( $user_id , 'my_preference',true) : null;
		$response['profile_image'] = $img;
		$response['news_profile_image'] = $img;

		return comman_custom_response($response);
	}

	public function mighty_get_customer_by_social ( $request ) {

        $parameters = $request->get_params();
		$email = $parameters['email'];
		$password = $parameters['accessToken'];
        $user = get_user_by('email', $email);

        $user_detail = array(
            'first_name' => $parameters['firstName'],
            'last_name'  => $parameters['lastName'],            
            'email'      => $email  
        );

        if ( !$user ) {
			$user = wp_create_user( $email, $password, $email );
			
			wp_update_user([
				'ID' => $user,
				'display_name' => $parameters['firstName'] .' '. $parameters['lastName'],
			]);
			update_user_meta( $user, 'loginType', $parameters['loginType']);
            update_user_meta( $user, 'first_name', trim( $user_detail['first_name'] ) );
            update_user_meta( $user, 'last_name', trim( $user_detail['last_name'] ) );            
        } else {
			// update_user_meta( $user->ID, 'loginType', $parameters['loginType']);
			
			$loginType = get_user_meta( $user->ID, 'loginType' , true );
            if( !isset($loginType) || $loginType == ''){
                return comman_message_response('You are already registered with us.',400);
            }
			
            wp_set_password( $password, $user->ID);
        }
        $u = new WP_User( $user);

        $response = mnGenerateToken( "username=".$email."&password=".$password  );
        
        return comman_custom_response(json_decode($response['body'],true));
    }
}