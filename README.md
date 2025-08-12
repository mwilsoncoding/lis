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
  MIX_ENV=prod \
    mix do phx.digest + release 
  DATABASE_PATH=/tmp/lis/lis.db \
  SECRET_KEY_BASE='kgxW7cyVxA4AjPYonbeQ6fngc3G9Gbs0KzoskpKlXEDu7l03Ow80gnubD/56yAPr' \
  _build/prod/rel/lis/bin/server
  ```

To visit the application in your browser:

- Click the `PORTS` tab in the code editor.
- Find port 4000 and click the globe icon in the Forwarded Address (the alt text for this icon reads `Open in Browser`).
- A new tab will open connected to the running application on the correct port.

#### Codespaces - Teardown

- Close the web browser tabs containing the editor and the application. At the time of this writing, GitHub only charges for the time that it is "on". The current default behavior is for the codespace to stop after 30 minutes of inactivity and to be deleted after 30 days of inactivity.

### Docker

Prerequisites:

- Install [Docker](https://www.docker.com/)

Steps:

- Execute the following commands to build and start the server:

  ```console
  docker build -t lis .
  docker run \
    --rm \
    -it \
    -p 4000:4000 \
    -e DATABASE_PATH=/tmp/lis/lis.db \
    -e SECRET_KEY_BASE='kgxW7cyVxA4AjPYonbeQ6fngc3G9Gbs0KzoskpKlXEDu7l03Ow80gnubD/56yAPr' \
    lis
  ```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

#### Docker - Teardown

- Press `Ctrl+C` in the terminal running the application to stop it.

### Bare Metal

Prerequisites:

- Install [Elixir](https://elixir-lang.org/install.html) v1.8.4 on top of [Erlang](https://elixir-lang.org/install.html#installing-erlang) v28.0.2

Steps:

- Execute the following commands to build and start the server:
  ```console
  MIX_ENV=prod \
    mix do phx.digest + release 
  DATABASE_PATH=/tmp/lis/lis.db \
  SECRET_KEY_BASE='kgxW7cyVxA4AjPYonbeQ6fngc3G9Gbs0KzoskpKlXEDu7l03Ow80gnubD/56yAPr' \
  _build/prod/rel/lis/bin/server
  ```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

#### Bare Metal - Teardown

- Press `Ctrl+C` in the terminal running the application to stop it.
