defmodule LISWeb.Components.Person do
  @moduledoc """
  This component displays information about a person.
  """

  use LISWeb, :html

  def details(assigns) do
    ~H"""
    <div class="flex flex-row justify-center">
      <div class="card w-96 bg-base-200 card-lg shadow-sm">
        <div class="card-body">
          <h2 class="card-title">
            {@title}
          </h2>
          <div class="flex flex-row justify-center">
            <div class="flex flex-col items-center">
              <div class="label">Name</div>
              <p>{@person.name}</p>
            </div>
            <div :if={@person.age} class="divider divider-horizontal" />
            <div :if={@person.age} class="flex flex-col items-center">
              <div class="label">Age</div>
              <p>{@person.age}</p>
            </div>
            <div class="divider divider-horizontal" />
            <div class="flex flex-col items-center">
              <div class="label">Title</div>
              <p>{@person.title}</p>
            </div>
            <div :if={@person.hometown} class="divider divider-horizontal" />
            <div :if={@person.hometown} class="flex flex-col items-center">
              <div class="label">Hometown</div>
              <p>{@person.hometown}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def inputs(assigns) do
    ~H"""
    <.input field={@form[:name]} type="text" label="Name" />
    <.input field={@form[:age]} type="number" label="Age" />
    <.input field={@form[:title]} type="text" label="Title" />
    <.input field={@form[:hometown]} type="text" label="Hometown" />
    """
  end
end
