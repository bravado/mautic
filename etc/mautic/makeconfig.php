<?php
$stderr = fopen('php://stderr', 'w');

fwrite($stderr, "\nWriting initial Mautic config\n");

$parameters = array(
	'db_driver'      => 'pdo_mysql',
	'install_source' => 'Docker'
);

foreach(getenv() as $key => $val) {
	if(substr($key,0, 7) == 'MAUTIC_') {
		if($key == 'MAUTIC_TRUSTED_PROXIES') {
			$val = json_decode($val);
		}
		$parameters[strtolower(substr($key, 7))] = empty($val) && !is_numeric($val) && !is_array($val) ? null : $val;
	} elseif($key == 'PHP_TIMEZONE') {
		$parameters['default_timezone'] = $val;
	}
}

$path     = '/var/www/local/config.php';
$rendered = "<?php\n\$parameters = ".var_export($parameters, true).";\n";

$status = file_put_contents($path, $rendered);

if ($status === false) {
	fwrite($stderr, "\nCould not write configuration file to $path, you can create this file with the following contents:\n\n$rendered\n");
}
