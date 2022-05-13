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
defmodule AutoApi.EngineState do
  @moduledoc """
  Keeps Engine state
  """

  alias AutoApi.{CommonData, State, UnitType}

  use AutoApi.State, spec_file: "engine.json"

  @type preconditioning_error ::
          :low_fuel
          | :low_battery
          | :quota_exceeded
          | :heater_failure
          | :component_failure
          | :open_or_unlocked
          | :ok
  @type preconditioning_status :: :standby | :heating | :cooling | :ventilation | :inactive

  @type t :: %__MODULE__{
          status: State.property(CommonData.on_off()),
          start_stop_state: State.property(CommonData.activity()),
          start_stop_enabled: State.property(CommonData.enabled_state()),
          preconditioning_enabled: State.property(CommonData.enabled_state()),
          preconditioning_active: State.property(CommonData.activity()),
          preconditioning_remaining_time: State.property(UnitType.duration()),
          preconditioning_error: State.property(preconditioning_error),
          preconditioning_status: State.property(preconditioning_status)
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 0>>
    iex> AutoApi.EngineState.from_bin(bin)
    %AutoApi.EngineState{status: %AutoApi.Property{data: :off}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.EngineState{status: %AutoApi.Property{data: :on}}
    iex> AutoApi.EngineState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
