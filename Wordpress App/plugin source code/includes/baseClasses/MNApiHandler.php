<?php

namespace Includes\baseClasses;


class MNApiHandler extends MNBase {

	public function init() {
		$api_folder_path = $this->plugin_path . 'includes/controllers/api/';
		$dir = scandir($api_folder_path);

		if (count($dir)) {
			foreach ($dir as $controller_name) {
				if ($controller_name !== "." && $controller_name !== "..") {
					$controller_name = explode( ".", $controller_name)[0];
					if($controller_name != '' && $controller_name != null) {
						$this->call($controller_name);
					}
				}
			}
		}
	}

	public function call($controllerName) {
		$controller = 'Includes\\controllers\\api\\' . $controllerName;
		(new $controller);
	}

}