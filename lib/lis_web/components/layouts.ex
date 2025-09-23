defmodule LISWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use LISWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar px-4 sm:px-6 lg:px-8 items-start">
      <ul class="menu menu-horizontal w-full relative z-10 flex items-center gap-4 px-4 sm:px-6 lg:px-8 justify-end">
        <%= if @current_scope do %>
          <li>
            {@current_scope.user.email}
          </li>
          <li>
            <.link href={~p"/users/settings"}>Settings</.link>
          </li>
          <li>
            <.link href={~p"/users/log-out"} method="delete">Log out</.link>
          </li>
        <% else %>
          <li>
            <.link href={~p"/users/register"}>Register</.link>
          </li>
          <li>
            <.link href={~p"/users/log-in"}>Log in</.link>
          </li>
        <% end %>
      </ul>
    </header>

    <main class="px-4 py-20 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-4xl space-y4">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.accessibility_menu />

    <.flash_group flash={@flash} />
    """
  end

  attr :id, :string, default: "accessibility-modal", doc: "the optional id of the modal"

  attr :font_face_event, :string,
    default: "lis:fontFace",
    doc: "the client-side JS event name to dispatch for updating the font face"

  attr :font_size_event, :string,
    default: "lis:fontSize",
    doc: "the client-side JS event name to dispatch for updating the font size"

  attr :update_selections_event, :string,
    default: "lis:loadA11ySelections",
    doc:
      "the client-side JS event name to dispatch to trigger accessibility settings selections (overrides the value option supplied to the inputs with client-side localStorage values, if present)"

  def accessibility_menu(assigns) do
    ~H"""
    <.button
      id={"#{@id}-btn"}
      phx-click={show_modal(JS.dispatch(@update_selections_event), @id)}
      class="btn btn-info fixed bottom-5 left-5"
    >
      Accessibility Menu
    </.button>

    <.modal
      id={@id}
      content_class="overflow-auto"
    >
      <.theme_toggle />
      <.input
        phx-change={JS.dispatch(@font_face_event)}
        class="w-full hover:bg-base-300 rounded"
        type="select"
        label="Font"
        id={"#{@id}-select-font-face"}
        name="font-face"
        value=""
        options={["EB Garamond", "Sans-serif", "Serif", "OpenDyslexic"]}
      />
      <.input
        phx-change={JS.dispatch(@font_size_event)}
        class="w-full hover:bg-base-300 rounded"
        type="select"
        label="Font Size"
        id={"#{@id}-select-font-size"}
        name="font-size"
        value=""
        options={["100%": 100, "125%": 125, "150%": 150, "200%": 200, "350%": 350, "500%": 500]}
      />
    </.modal>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <.input
      id="theme-toggle"
      name="theme-toggle"
      type="select"
      label="Theme"
      class="w-full hover:bg-base-300 rounded"
      value=""
      options={[System: "system", Light: "light", Dark: "dark"]}
      phx-change={JS.dispatch("phx:set-theme")}
    />
    """
  end
end
