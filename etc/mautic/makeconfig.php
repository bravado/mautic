<?php
$stderr = fopen('php://stderr', 'w');

fwrite($stderr, "\nWriting initial Mautic config\n");

$parameters = array(
	'db_driver'      => 'pdo_mysql',
	'install_source' => 'Docker'
);

//foreach($_ENV as $key => $val) {
//	if(substr($key,0, 7) == 'MAUTIC_') {
//		$parameters[strtolower(substr($key, 6))] = empty($val) ? null : $val;
//	}
//}

if(!empty($_ENV['TRUSTED_PROXIES'])) {
    $proxies = explode(',', $_ENV['TRUSTED_PROXIES']);
    $parameters['trusted_proxies'] = $proxies;
}

if(array_key_exists('PHP_TIMEZONE', $_ENV)) {
    $parameters['default_timezone'] = $_ENV['PHP_TIMEZONE'];
}

$path     = '/var/www/local/config.php';
$rendered = "<?php\n\$parameters = ".var_export($parameters, true).";\n";

$status = file_put_contents($path, $rendered);

if ($status === false) {
	fwrite($stderr, "\nCould not write configuration file to $path, you can create this file with the following contents:\n\n$rendered\n");
}
