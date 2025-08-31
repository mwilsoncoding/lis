# LIS

This repository contains my demo web application for an interview with the Legislative Information Systems agency.

## How to Run

There are many ways to run this application. Here are 3 options:

### Codespaces

Note: Codespaces service disruptions may cause 502s unrelated to the demo application's performance.

Steps:

- Click the `Code` button on the main page of this repository.
- Select the `Codespaces` tab in the drop-down.
- Click the button to create a codespace on main.
- A new tab will open where your codespace is created.
- Once the editor finishes loading, execute the following commands to build and start the server:
  ```console
  mkdir -p priv/cert
  openssl req \
    -x509 \
    -newkey rsa:4096 \
    -keyout priv/cert/selfsigned_key.pem \
    -out priv/cert/selfsigned.pem \
    -sha256 \
    -days 3650 \
    -noenc \
    -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname" \
    -subj "/CN=localhost"
  MIX_ENV=prod mix phx.digest
  MIX_ENV=prod mix release --overwrite
  LIS_SSL_KEY_PATH=$(pwd)/priv/cert/selfsigned_key.pem \
  LIS_SSL_CERT_PATH=$(pwd)/priv/cert/selfsigned.pem \
  PHX_HOST=localhost \
  DATABASE_PATH=/tmp/lis/lis.db \
  SECRET_KEY_BASE='kgxW7cyVxA4AjPYonbeQ6fngc3G9Gbs0KzoskpKlXEDu7l03Ow80gnubD/56yAPr' \
  _build/prod/rel/lis/bin/server
  ```

To visit the application in your browser:

- Click the `PORTS` tab in the code editor.
- Find port 443 and click the globe icon in the Forwarded Address (the alt text for this icon reads `Open in Browser`).
- A new tab will open connected to the running application on the correct port.

#### Codespaces - Teardown

- Close the web browser tabs containing the editor and the application. At the time of this writing, GitHub only charges for the time that it is "on". The current default behavior is for the codespace to stop after 30 minutes of inactivity and to be deleted after 30 days of inactivity.

### Docker

Prerequisites:

- Install [Docker](https://www.docker.com/)

Steps:

- Clone this repository to your local machine.
- `cd` into the new directory.
- Execute the following commands to build and start the server:

  ```console
  mkdir -p priv/cert
  openssl req \
    -x509 \
    -newkey rsa:4096 \
    -keyout priv/cert/selfsigned_key.pem \
    -out priv/cert/selfsigned.pem \
    -sha256 \
    -days 3650 \
    -noenc \
    -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname" \
    -subj "/CN=localhost"
  docker build -t lis .
  docker run \
    --rm \
    -it \
    --mount "type=bind,source=$(pwd)/priv/cert,target=/cert" \
    -p 80:80 \
    -p 443:443 \
    -e LIS_SSL_KEY_PATH=/cert/selfsigned_key.pem \
    -e LIS_SSL_CERT_PATH=/cert/selfsigned.pem \
    -e PHX_HOST=localhost \
    -e DATABASE_PATH=/tmp/lis/lis.db \
    -e SECRET_KEY_BASE='kgxW7cyVxA4AjPYonbeQ6fngc3G9Gbs0KzoskpKlXEDu7l03Ow80gnubD/56yAPr' \
    lis
  ```

Now you can visit [`localhost`](https://localhost) from your browser.

#### Docker - Teardown

- Press `Ctrl+C` in the terminal running the application to stop it.

### Bare Metal

Prerequisites:

- Install [Elixir](https://elixir-lang.org/install.html) v1.8.4 on top of [Erlang](https://elixir-lang.org/install.html#installing-erlang) v28.0.2

Steps:

- Clone this repository to your local machine.
- `cd` into the new directory.
- Execute the following commands to build and start the server:
  ```console
  mkdir -p priv/cert
  openssl req \
    -x509 \
    -newkey rsa:4096 \
    -keyout priv/cert/selfsigned_key.pem \
    -out priv/cert/selfsigned.pem \
    -sha256 \
    -days 3650 \
    -noenc \
    -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname" \
    -subj "/CN=localhost"
  MIX_ENV=prod mix do phx.digest
  MIX_ENV=prod mix do release --overwrite
  LIS_SSL_KEY_PATH=$(pwd)/priv/cert/selfsigned_key.pem \
  LIS_SSL_CERT_PATH=$(pwd)/priv/cert/selfsigned.pem \
  PHX_HOST=localhost \
  DATABASE_PATH=/tmp/lis/lis.db \
  SECRET_KEY_BASE='kgxW7cyVxA4AjPYonbeQ6fngc3G9Gbs0KzoskpKlXEDu7l03Ow80gnubD/56yAPr' \
  _build/prod/rel/lis/bin/server
  ```

Now you can visit [`localhost`](https://localhost) from your browser.

#### Bare Metal - Teardown

- Press `Ctrl+C` in the terminal running the application to stop it.

## Navigating the Demo App

When you first visit the root page, `/`, you will be asked to log in.

If you have not yet registered your email address, click the `Sign up` link.

Enter your email address and click `Create an account`.

In the current production version of the application, emails are logged in full to the console. View this output and click the link "sent" in the email to log in.

Choose to remain logged in after the session ends or to stay logged in until you log out.

Once registered, you can log in redirected to the data entry page, `/persons`.

The data entry page displays a form for entering demographic data about a person.

Tooltip errors appear when you click the `Save` button without any information in the `Name` or `Title` fields.

Clicking the `List` button takes you to the `/persons` endpoint without saving any information entered into the form.

Clicking the `Save` button with data in the required fields will result in a new `Person` added into the system. You will be redirected to a confirmation page displaying the newly entered information with a table of previous entries.

On the `/persons` page, clicking any value under the `Name` column in the table of `Person`s will take you to a page displaying only that `Person`'s information.