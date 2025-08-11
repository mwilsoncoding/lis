defmodule LISWeb.PersonHTML do
  @moduledoc """
  This module contains pages rendered by PersonController.

  See the `person_html` directory for all templates available.
  """
  use LISWeb, :html

  embed_templates "person_html/*"
end
