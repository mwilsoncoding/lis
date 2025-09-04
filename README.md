# LIS

This repository contains my demo web application for an interview with the Legislative Information Systems agency.

## How to Run

There are many ways to run this application. Here are 3 options:

### Codespaces

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
- Find port 80 and click the globe icon in the Forwarded Address (the alt text for this icon reads `Open in Browser`).
- A new tab will open connected to the running application on the correct port.

Notes:

- Codespaces service disruptions may cause 502s unrelated to the demo application's performance.
- Port 443 would be used in production, but this demo uses self-signed certificates, which cause GitHub's security measures to 502 access to this port.

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

Note: this application supports Bring Your Own TLS-Certificate out-of-the-box. For the purposes of demonstration, a self-signed certificate is used. Browsers will complain about this, but most will offer the user an option to proceed to the "unsafe" site. Click this option to proceed to the Demo.

When you first visit the root page, `/`, you will be asked to log in.

If you have not yet registered your email address, click the `Sign up` link.

Enter your email address and click `Create an account`.

In the current production version of the application, emails are logged in full to the console. View this output and click the link "sent" in the email to log in.

Choose to remain logged in or to have your session log you out. If you choose to remain logged in, you will be logged out after 14 days of inactivity for security.

Once logged in, you will be redirected to the data entry page, `/persons`.

The data entry page displays a listing of all persons entered by the current user (your email, in this case).

Click the `New Person` button to bring up the person entry form.

Tooltip errors appear when you click the `Save` button without any information in the `Name` or `Title` fields.

Clicking the `Save` button with data in the required fields will result in a new `Person` added into the system. Once saved, the data is appended to the bottom of the persons listing. The newly created person data is also displayed in a card above the persons listing, for convenience.

On the `/persons` page, clicking any row in the table of `Person`s will take you to a page displaying only that `Person`'s information.

Editing a `Person` is supported on both the `/persons` page and the `/persons/:id` page.

On the `/persons` page, each row contains an `Edit` action and a `Delete` action.

  - Clicking the `Edit` action on a given row brings up the `Person` data entry form, pre-populated with the row's data. Saving updated values in this form will update the `Person` record in the database and these changes will be reflected in the `/persons` listing immediately.
  - Clicking the `Delete` action results in the `Person` record being deleted from the database and from the user interface.

On the `/persons/:id` page, clicking the `Edit` button brings up the same data entry form as on the `/persons` page, pre-populated with the user's data, synchronized with the database on `Save`, and reflected on the page afterward.