<?php

namespace Includes\baseClasses;


class MNActivate extends MNBase {

	public static function activate() {
		( new MNGetDependency( 'jwt-authentication-for-wp-rest-api' ) )->getPlugin();
		( new MNGetDependency( 'meta-box' ) )->getPlugin();
		( new MNGetDependency( 'onesignal-free-web-push-notifications' ) )->getPlugin();
		( new MNGetDependency( 'categories-images' ) )->getPlugin();
		
		require_once MIGHTYNEWS_API_DIR . 'includes/db/class.mightynews.db.php';		
		
	}

	public function init() {

		if ( isset( $_REQUEST['page'] ) && strpos($_REQUEST['page'], "news-configuration") !== false ) {
			// Enqueue Admin-side assets...
            add_action( 'admin_enqueue_scripts', array( $this, 'enqueueStyles' ) );
            add_action( 'admin_enqueue_scripts', array( $this, 'enqueueScripts' ) );

        }

		// API handle
		( new MNApiHandler() )->init();

		// Action to add option in the sidebar...
		add_action( 'admin_menu', array( $this, 'adminMenu' ) );

		// Action to change authentication api response ...
		add_filter( 'jwt_auth_token_before_dispatch', array($this, 'jwtAuthenticationResponse'), 10, 2 );


	}

	public function adminMenu() {
		$user = wp_get_current_user();
		$roles = ( array ) $user->roles;
	   	if( in_array('administrator' , $roles) ){
			add_menu_page( __( 'App Configuration' ), 'App Configuration', 'read', 'news-configuration',  [
				$this,
				'adminDashboard'
			], $this->plugin_url . 'assets/images/sidebar-icon.png', 99 );
		}
	}

    public function adminDashboard() {
        include( MIGHTYNEWS_API_DIR . 'resources/views/mn_admin_panel.php' );
    }



	public function enqueueStyles() {
        wp_enqueue_style( 'mn_bootstrap_css', MIGHTYNEWS_API_DIR_URI . 'assets/css/bootstrap.min.css' );
        wp_enqueue_style('mn_bootstrap_select', MIGHTYNEWS_API_DIR_URI . 'admin/css/bootstrap-select.css');
        wp_enqueue_style('mn_custom', MIGHTYNEWS_API_DIR_URI . 'assets/css/custom.css');
    }

	public function enqueueScripts() {
        wp_enqueue_script( 'mn_bootstrap_js', MIGHTYNEWS_API_DIR_URI . 'assets/js/bootstrap.min.js', [ 'jquery' ], false, true );
        wp_enqueue_script( 'mn_js_popper', MIGHTYNEWS_API_DIR_URI . 'admin/js/popper.min.js', [ 'jquery' ], false, false );
        wp_enqueue_script( 'mn_bootstrap_select', MIGHTYNEWS_API_DIR_URI . 'admin/js/bootstrap-select.js', [ 'jquery' ], false, true );
        wp_enqueue_script('mn_sweetalert', MIGHTYNEWS_API_DIR_URI . 'admin/js/sweetalert.min.js', ['jquery'], false, true);
        wp_enqueue_script('mn_custom', MIGHTYNEWS_API_DIR_URI . 'assets/js/custom.js', ['jquery'], false, true);
        wp_localize_script('mn_custom', 'mn_localize', array(
            'ajaxurl' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('get_mn_admin_settings')
        ));

		wp_localize_script( 'mn_js_bundle', 'request_data', array(
			'ajaxurl'         => admin_url( 'admin-ajax.php' ),
			'nonce'           => wp_create_nonce( 'ajax_post' ),
			'mightynewsPluginURL' => MIGHTYNEWS_API_DIR_URI,
		) );

		wp_enqueue_script( 'mn_js_bundle' );
	}

	public function jwtAuthenticationResponse( $data, $user ) {

		$img       = get_user_meta( $user->ID, 'mighty_profile_image' , true );
		$user_info = get_userdata( $user->ID );

		$data['first_name'] = $user_info->first_name;
		$data['last_name']  = $user_info->last_name;
		$data['user_id']    = $user->ID;
		$data['my_topics'] 	= ( get_user_meta( $user->ID , 'my_topics' ,true) != null ) ? json_decode(get_user_meta( $user->ID , 'my_topics' ,true)) : [];
		$data['my_preference'] = ( get_user_meta( $user->ID , 'my_preference' ,true) != null ) ? get_user_meta( $user->ID , 'my_preference' ,true) : null;
		$data['profile_image'] = $img;
		$data['news_profile_image'] = $img;

		return $data;
	}

}


