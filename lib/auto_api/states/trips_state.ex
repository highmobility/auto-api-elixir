defmodule AutoApi.TripsState do
  @moduledoc """
  Trips state
  """

  alias AutoApi.{CommonData, State, UnitType}

  defstruct type: nil,
            driver_name: nil,
            description: nil,
            start_time: nil,
            end_time: nil,
            start_address: nil,
            end_address: nil,
            start_coordinates: nil,
            end_coordinates: nil,
            start_odometer: nil,
            end_odometer: nil,
            average_fuel_consumption: nil,
            distance: nil,
            start_address_components: [],
            end_address_components: []

  use AutoApi.State, spec_file: "trips.json"

  @type type :: :single | :multi

  @type address_component_types ::
          :city
          | :country
          | :country_short
          | :district
          | :postal_code
          | :street
          | :state_province
          | :other

  @type address_component :: %{type: address_component_types(), value: String.t()}

  @type t :: %__MODULE__{
          type: State.property(type()),
          driver_name: State.property(String.t()),
          description: State.property(String.t()),
          start_time: State.property(DateTime.t()),
          end_time: State.property(DateTime.t()),
          start_address: State.property(String.t()),
          end_address: State.property(String.t()),
          start_coordinates: State.property(CommonData.coordinates()),
          end_coordinates: State.property(CommonData.coordinates()),
          start_odometer: State.property(UnitType.length()),
          end_odometer: State.property(UnitType.length()),
          average_fuel_consumption: State.property(UnitType.fuel_efficiency()),
          distance: State.property(UnitType.length()),
          start_address_components: State.multiple_property(address_component()),
          end_address_components: State.multiple_property(address_component())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 0>>
    iex> AutoApi.TripsState.from_bin(bin)
    %AutoApi.TripsState{type: %AutoApi.PropertyComponent{data: :single}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.TripsState{type: %AutoApi.PropertyComponent{data: :multi}}
    iex> AutoApi.TripsState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
