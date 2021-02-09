# Example of Building PHP functions with Docker container images

This example shows how to build a Docker container with a PHP application
for to be deployed on *AWS Lambda*.

This is based on the ability of [execute custom containers in AWS Lambda][1]

This example is difference [from others][2] because it DOES NOT inherit
from lambda image (`FROM public.ecr.aws/lambda/provided`) instead it INHERITS from
official `FROM php` image.

In fact the only requirement for execute your custom container in Lambda is to
have an *ENTRYPOINT* for manipulate the Lambda API (environment variable
`AWS_LAMBDA_RUNTIME_API` and their respective HTTP calls)

```dockerfile
ENTRYPOINT runtime/bootstrap.php
```

I've chosen to use an **internal** class from *bref* for do the heavylift and
also to provide a bridge for *PSR-7 HTTP messages*.

```php
$lambdaRuntime = Bref\Runtime\LambdaRuntime::fromEnvironmentVariable();

$handler = require __DIR__ . '/../public/index.php';

$lambdaRuntime->processNextEvent($handler);
```

This example provides you with the *Lambda RIE* (Runtime Interface Emulator) for
emulate Lambda environment in your development environment (Your computer).

```dockerfile
COPY --from=public.ecr.aws/lambda/provided /usr/local/bin/aws-lambda-rie /usr/local/bin/aws-lambda-rie
ENTRYPOINT aws-lambda-rie runtime/bootstrap.php
```

For web server applications it's mandatory to format the HTTP request (and response)
as a valid payload. This is usually done by *AWS API Gateway*, but for your
development environment the [`maks3w/aws-lambda-rie-gateway` image][3] is provided
as a lightweight HTTP server container for *API Gateway* emulation
(based in the work of [*eagletmt/aws-lambda-rie-gateway*][4])


[1]: https://aws.amazon.com/es/blogs/aws/new-for-aws-lambda-container-image-support/
[2]: https://aws.amazon.com/es/blogs/compute/building-php-lambda-functions-with-docker-container-images/
[3]: https://hub.docker.com/r/maks3w/aws-lambda-rie-gateway
[4]: https://github.com/eagletmt/aws-lambda-rie-gateway
