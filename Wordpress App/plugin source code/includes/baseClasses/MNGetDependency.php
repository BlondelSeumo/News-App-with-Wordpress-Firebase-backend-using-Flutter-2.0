<?php

namespace Includes\baseClasses;


use Automatic_Upgrader_Skin;
use Plugin_Upgrader;

class MNGetDependency {

    protected $pluginName;

    public function __construct($pluginName) {
        $this->pluginName = $pluginName;
    }

    public function getPlugin()
    {
        $basename = '';
        $plugins = get_plugins();
        foreach ($plugins as $key => $data) {

            if ($data['TextDomain'] === $this->pluginName) {
                $basename = $key;
            }
        }
        $plugin_data = $this->getPluginData($this->pluginName);
        if ($this->isPluginInstalled($basename)) {
            if (!is_plugin_active($basename)) {
                activate_plugin($this->callPluginPath(WP_PLUGIN_DIR . DIRECTORY_SEPARATOR . $basename), '', false, false);
                return true;
            }
        } else {
            if (isset($plugin_data->download_link)) {
                $this->installPlugin($plugin_data->download_link);
                return true;
            }
        }
        return false;

    }

    public function getPluginData($slug = '') {
        $args = array(
            'slug' => $slug,
            'fields' => array(
                'version' => false,
            ),
        );

        $response = wp_remote_post(
            'http://api.wordpress.org/plugins/info/1.0/',
            array(
                'body' => array(
                    'action' => 'plugin_information',
                    'request' => serialize((object) $args),
                ),
            )
        );

        if (is_wp_error($response)) {
            return false;
        } else {
            $response = unserialize(wp_remote_retrieve_body($response));

            if ($response) {
                return $response;
            } else {
                return false;
            }
        }
    }

    public function isPluginInstalled($basename) {
        if (!function_exists('get_plugins')) {
            include_once ABSPATH . 'wp-admin/includes/plugin.php';
        }

        $plugins = get_plugins();

        return isset($plugins[$basename]);
    }

    public function installPlugin($plugin_url) {
        include_once ABSPATH . 'wp-admin/includes/file.php';
        include_once ABSPATH . 'wp-admin/includes/class-wp-upgrader.php';
        include_once ABSPATH . 'wp-admin/includes/class-automatic-upgrader-skin.php';

        $skin = new Automatic_Upgrader_Skin;
        $upgrade = new Plugin_Upgrader($skin);
        $upgrade->install($plugin_url);

        // activate plugin
        activate_plugin($upgrade->plugin_info(), '', false, false);

        return $skin->result;
    }

    public function callPluginPath($path) {
        $path = str_replace(['//', '\\\\'], ['/', '\\'], $path);

        return str_replace(['/', '\\'], DIRECTORY_SEPARATOR, $path);
    }

}