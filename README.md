Simple project using Docker Compose to demonstrate load balancing cache issue in Livewire.

Logging in brings up a Filament dashboard configured to show 10 chart widgets in a 2-column/5-row layout. One or more of the chart requests to `/livewire/update` will fail.

This project is configured to serve all endpoints over HTTPS. Use an SSL terminating service like [Ngrok](https://ngrok.com).




### Install and Run

```
git clone https://github.com/peterjbassi/filamentapp.git
```
```
docker compose up -d
```
```
mysql -h 127.0.0.1 -u root -p -e 'create database charts'; # password is charts
```
```
docker compose exec charts php artisan migrate  
```
```
docker compose exec charts php artisan make:filament-user --name charts --email charts@charts.com --password charts
```
```
ngrok http 8080
```
Open your browser to `https://<your_domain>/admin`

    Username: charts@charts.com
    Password: charts