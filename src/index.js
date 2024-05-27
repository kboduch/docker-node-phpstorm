// Unable to debug this line with the "Attach to Node.js" configuration. "Node.js" configuration works.
console.log('Hello World! 123 123');

// Ctrl + C doesn't trigger functions below when docker compose up is used.
// Something is intercepting the signal. Docker compose? nodemon?
//
// If I stop the container via:
// - the Docker Desktop app, stop button
// - docker compose up and in a different terminal docker compose stop SERVICE command
// - docker compose run SERVICE node and then Ctrl + C
// then the process receives the signal configured in the docker-compose.yml file.
process.on('SIGTERM', function () {
        console.log('Got SIGTERM.');
        process.exit(0);
    }
);
process.on('SIGINT', function () {
        console.log('Got SIGINT.');
        process.exit(0);
    }
);

let i = 0;
setInterval(() => console.log(i++, 178 ), 1000);
