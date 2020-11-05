defmodule AutoApiL11.LightsState do
  @moduledoc """
  StartStop state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct front_exterior_light: nil,
            rear_exterior_light: nil,
            ambient_light_colour: nil,
            reverse_light: nil,
            emergency_brake_light: nil,
            fog_lights: [],
            reading_lamps: [],
            interior_lights: [],
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/lights.json"

  @type front_exterior_light :: :inactive | :active | :active_with_full_beam | :dlr | :automatic
  @type light_location :: :front | :rear
  @type ambient_light :: %{red: integer, green: integer, blue: integer}
  @type fog_light :: %PropertyComponent{
          data: %{location: light_location, state: CommonData.activity()}
        }
  @type reading_lamp :: %PropertyComponent{
          data: %{
            location: CommonData.location(),
            state: CommonData.activity()
          }
        }
  @type interior_lights :: %PropertyComponent{
          data: %{
            location: light_location,
            state: CommonData.activity()
          }
        }

  @type t :: %__MODULE__{
          front_exterior_light: %PropertyComponent{data: front_exterior_light} | nil,
          rear_exterior_light: %PropertyComponent{data: CommonData.activity()} | nil,
          ambient_light_colour: %PropertyComponent{data: ambient_light} | nil,
          reverse_light: %PropertyComponent{data: CommonData.activity()} | nil,
          emergency_brake_light: %PropertyComponent{data: CommonData.activity()} | nil,
          fog_lights: list(fog_light),
          reading_lamps: list(reading_lamp),
          interior_lights: list(interior_lights),
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<5, 0, 4, 1, 0, 1, 1>>
    iex> AutoApiL11.LightsState.from_bin(bin)
    %AutoApiL11.LightsState{reverse_light: %AutoApiL11.PropertyComponent{data: :active}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.LightsState{reverse_light: %AutoApiL11.PropertyComponent{data: :active}}
    iex> AutoApiL11.LightsState.to_bin(state)
    <<5, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
