# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.TripsState do
  @moduledoc """
  Trips state
  """

  alias AutoApi.{CommonData, State, UnitType}

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
