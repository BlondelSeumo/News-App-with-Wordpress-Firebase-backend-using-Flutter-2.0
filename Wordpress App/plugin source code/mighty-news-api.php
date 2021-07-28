<?php

/**
 * @wordpress-plugin
 * Plugin Name:       mighty-news-api
 * Plugin URI:        https://meetmighty.com/
 * Description:       Mighty News api mobile plugin
 * Version:           1.3.2
 * Author:            MeetMighty
 * Author URI:        https://meetmighty.com/
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       mighty-news-api
 * Domain Path:       /languages
 */

// If this file is called directly, abort.
use Includes\baseClasses\MNActivate;
use Includes\baseClasses\MNDeactivate;

/**
 * Currently plugin version.
 * Start at version 1.1.1 and use SemVer - https://semver.org
 * Rename this for your plugin and update it as you release new versions.
 */
define( 'MIGHTYNEWS_API_VERSION', '1.3.2' );

defined( 'ABSPATH' ) or die( 'Something went wrong' );

// Require once the Composer Autoload
if ( file_exists( dirname( __FILE__ ) . '/vendor/autoload.php' ) ) {
	require_once dirname( __FILE__ ) . '/vendor/autoload.php';
} else {
	die( 'Something went wrong' );
}

if (!defined('MIGHTYNEWS_API_DIR'))
{
	define('MIGHTYNEWS_API_DIR', plugin_dir_path(__FILE__));
}

if (!defined('MIGHTYNEWS_API_DIR_URI'))
{
	define('MIGHTYNEWS_API_DIR_URI', plugin_dir_url(__FILE__));
}


if (!defined('MIGHTYNEWS_API_NAMESPACE'))
{
	define('MIGHTYNEWS_API_NAMESPACE', "news");
}

if (!defined('MIGHTYNEWS_API_PREFIX'))
{
	define('MIGHTYNEWS_API_PREFIX', "mn_");
}


if (!defined('JWT_AUTH_SECRET_KEY')){
	define('JWT_AUTH_SECRET_KEY', 'your-top-secrect-key');
}

if (!defined('JWT_AUTH_CORS_ENABLE')){
	define('JWT_AUTH_CORS_ENABLE', true);
}
if ( class_exists('RW_Meta_Box') ) {
	include( MIGHTYNEWS_API_DIR . 'includes/meta-box/feature_post_field.php' );
	include( MIGHTYNEWS_API_DIR . 'includes/meta-box/video_post_page.php' );

	add_filter('onesignal_send_notification', 'onesignal_send_notification_filter', 10, 4);

	function onesignal_send_notification_filter($fields, $new_status, $old_status, $post)
	{
		unset($fields['url']);

		$video_url = isset($_POST['video_url']) ? $_POST['video_url'] : "";
		$video_type = isset($_POST['video_type']) ? $_POST['video_type'] : "";

		$fields['data'] = [
			"ID" => (string)$post->ID,
			"video_type" => $video_type,
			"video_url" => $video_url
		];

		return $fields;
	}
}
require_once( ABSPATH . 'wp-admin/includes/image.php' );
require_once( ABSPATH . 'wp-admin/includes/file.php' );
require_once( ABSPATH . 'wp-admin/includes/media.php' );

add_filter( 'plugin_row_meta', 'custom_plugin_row_meta', 10, 2 );

function custom_plugin_row_meta( $plugin_meta, $plugin_file ) {
	
	if ( $plugin_file == plugin_basename( __FILE__ ) )
	{
        $new_links = [
			'doc' => '<a href="https://meetmighty.com/codecanyon/document/mightynews/" target="_blank">Documentation</a>',
			'support' => '<a href="https://support.meetmighty.com/" target="_blank">Support</a>',
		];
         
        $plugin_meta = array_merge( $plugin_meta, $new_links );
    }
	
    return $plugin_meta;
}

/**
 * The code that runs during plugin activation
 */
register_activation_hook( __FILE__, [ MNActivate::class, 'activate'] );

/**
 * The code that runs during plugin deactivation
 */
register_deactivation_hook( __FILE__, [MNDeactivate::class, 'init'] );


( new MNActivate )->init();