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
defmodule AutoApi.ChargingSessionState do
  @moduledoc """
  Keeps ChargingSession state
  """

  alias AutoApi.{CommonData, State, UnitType}

  use AutoApi.State, spec_file: "charging_session.json"

  @type charging_cost :: %{
          currency: String.t(),
          calculated_charging_cost: float(),
          calculated_savings: float(),
          simulated_immediate_charging_cost: float()
        }

  @type charging_location :: %{
          municipality: String.t(),
          formatted_address: String.t(),
          street_address: String.t()
        }

  @type public_charging_points :: %{
          city: String.t(),
          postal_code: String.t(),
          street: String.t(),
          provider: String.t()
        }

  @type t :: %__MODULE__{
          public_charging_points: State.multiple_property(public_charging_points()),
          displayed_state_of_charge: State.property(float()),
          displayed_start_state_of_charge: State.property(float()),
          business_errors: State.multiple_property(String.t()),
          time_zone: State.property(String.t()),
          start_time: State.property(DateTime.t()),
          end_time: State.property(DateTime.t()),
          total_charging_duration: State.property(UnitType.duration()),
          calculated_energy_charged: State.property(UnitType.energy()),
          energy_charged: State.property(UnitType.energy()),
          preconditioning_state: State.property(CommonData.activity()),
          odometer: State.property(UnitType.length()),
          charging_cost: State.property(charging_cost()),
          location: State.property(charging_location())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<11, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.ChargingSessionState.from_bin(bin)
    %AutoApi.ChargingSessionState{preconditioning_state: %AutoApi.Property{data: :active}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.ChargingSessionState{preconditioning_state: %AutoApi.Property{data: :inactive}}
    iex> AutoApi.ChargingSessionState.to_bin(state)
    <<11, 0, 4, 1, 0, 1, 0>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
