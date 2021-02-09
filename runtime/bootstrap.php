#!/usr/bin/env php

<?php

use Bref\Runtime\LambdaRuntime;

require  __DIR__ . '/../vendor/autoload.php';

$lambdaRuntime = LambdaRuntime::fromEnvironmentVariable();

$handler = require __DIR__ . '/../public/index.php';

$lambdaRuntime->processNextEvent($handler);
