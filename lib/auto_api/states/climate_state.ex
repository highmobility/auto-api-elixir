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
defmodule AutoApi.ClimateState do
  @moduledoc """
  Climate state
  """

  alias AutoApi.{CommonData, State, UnitType}

  use AutoApi.State, spec_file: "climate.json"

  @type weekday ::
          :monday | :tuesday | :wednesday | :thursday | :friday | :saturday | :sunday | :automatic

  @type hvac_weekday_starting_time :: %{
          weekday: weekday(),
          time: CommonData.time()
        }

  @type t :: %__MODULE__{
          inside_temperature: State.property(UnitType.temperature()),
          outside_temperature: State.property(UnitType.temperature()),
          driver_temperature_setting: State.property(UnitType.temperature()),
          passenger_temperature_setting: State.property(UnitType.temperature()),
          hvac_state: State.property(CommonData.activity()),
          defogging_state: State.property(CommonData.activity()),
          defrosting_state: State.property(CommonData.activity()),
          ionising_state: State.property(CommonData.activity()),
          defrosting_temperature_setting: State.property(UnitType.temperature()),
          hvac_weekday_starting_times: State.multiple_property(hvac_weekday_starting_time()),
          rear_temperature_setting: State.property(UnitType.temperature())
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.ClimateState.from_bin(<<1, 0, 13, 1, 0, 10, 23, 1, 64, 60, 0, 0, 0, 0, 0, 0>>)
    %AutoApi.ClimateState{inside_temperature: %AutoApi.PropertyComponent{data: {28.0, :celsius}}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.ClimateState{inside_temperature: %AutoApi.PropertyComponent{data: {28.00, :celsius}}}
    iex> AutoApi.ClimateState.to_bin(state)
    <<1, 0, 13, 1, 0, 10, 23, 1, 64, 60, 0, 0, 0, 0, 0, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
