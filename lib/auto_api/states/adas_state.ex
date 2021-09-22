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
defmodule AutoApi.AdasState do
  @moduledoc """
  Keeps Adas state
  """

  alias AutoApi.{CommonData, State}

  use AutoApi.State, spec_file: "adas.json"

  @type blind_spot_coverage :: :regular | :trailer

  @type lane_keep_assist_state :: %{
          location: :left | :right,
          state: CommonData.activity()
        }
  @type muted :: :muted | :not_muted

  @type park_assist :: %{
          location: CommonData.location_longitudinal(),
          alarm: CommonData.activity(),
          muted: muted()
        }

  @type t :: %__MODULE__{
          status: State.property(CommonData.on_off()),
          alertness_system_status: State.property(CommonData.activity()),
          forward_collision_warning_system: State.property(CommonData.activity()),
          blind_spot_warning_state: State.property(CommonData.activity()),
          blind_spot_warning_system_coverage: State.property(blind_spot_coverage()),
          rear_cross_warning_system: State.property(CommonData.activity()),
          automated_parking_brake: State.property(CommonData.activity()),
          lane_keep_assist_system: State.property(CommonData.on_off()),
          lane_keep_assists_states: State.multiple_property(lane_keep_assist_state()),
          park_assists: State.multiple_property(park_assist()),
          blind_spot_warning_system: State.property(CommonData.on_off())
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.AdasState.from_bin(bin)
    %AutoApi.AdasState{status: %AutoApi.Property{data: :on}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.AdasState{status: %AutoApi.Property{data: :off}}
    iex> AutoApi.AdasState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 0>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
