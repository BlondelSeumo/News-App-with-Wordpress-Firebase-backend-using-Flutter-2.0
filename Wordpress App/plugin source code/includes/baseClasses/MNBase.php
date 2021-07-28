<?php

/**
 * @package  MightyNewsPlugin
 */

namespace Includes\baseClasses;

class MNBase {

	public $plugin_path;

	public $nameSpace;

	public $plugin_url;

	public $plugin;

	public $dbConfig;

	private $pluginPrefix;

	public $plugin_version;


	public function __construct() {

		$this->plugin_path = plugin_dir_path( dirname( __FILE__, 2 ) );
		$this->plugin_url  = plugin_dir_url( dirname( __FILE__, 2 ) );

		$this->nameSpace    = MIGHTYNEWS_API_NAMESPACE;
		$this->pluginPrefix = MIGHTYNEWS_API_PREFIX;

		$this->plugin_version = '1.3.2';

		$this->plugin = plugin_basename( dirname( __FILE__, 3 ) ) . '/mighty-news-api.php';

		$this->dbConfig = [
			'user' => DB_USER,
			'pass' => DB_PASSWORD,
			'db'   => DB_NAME,
			'host' => DB_HOST
		];

	}

	public function get_namespace() {
		return $this->nameSpace;
	}

	protected function getPluginPrefix() {
		return $this->pluginPrefix;
	}

}
