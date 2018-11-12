# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.RooftopControlCommand do
  @moduledoc """
  Handles Hood commands and apply binary commands on `%AutoApi.RooftopControlState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.RooftopControlState
  alias AutoApi.RooftopControlCapability

  @doc """
  Parses the binary command and makes changes or returns the state

        iex> AutoApi.RooftopControlCommand.execute(%AutoApi.RooftopControlState{}, <<0x00>>)
        {:state, %AutoApi.RooftopControlState{}}

        iex> command = <<0x01>> <> <<0x01, 1::integer-16, 100>>
        iex> AutoApi.RooftopControlCommand.execute(%AutoApi.RooftopControlState{}, command)
        {:state_changed, %AutoApi.RooftopControlState{dimming: 100}}

  """
  @spec execute(RooftopControlState.t(), binary) ::
          {:state | :state_changed, RooftopControlState.t()}
  def execute(%RooftopControlState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%RooftopControlState{} = state, <<0x01, ds::binary>>) do
    new_state = RooftopControlState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts RooftopControlCommand state to capability's state in binary

        iex> properties = [:convertible_roof_state]
        iex> AutoApi.RooftopControlCommand.state(%AutoApi.RooftopControlState{convertible_roof_state: :loading_position, properties: properties})
        <<1, 3, 0, 1, 7>>
  """
  @spec state(RooftopControlState.t()) :: binary
  def state(%RooftopControlState{} = state) do
    <<0x01, RooftopControlState.to_bin(state)::binary>>
  end

  @doc """
  Converts command to binary format

      iex> AutoApi.RooftopControlCommand.to_bin(:get_rooftop_state, [])
      <<0x00>>
  """
  @spec to_bin(RooftopControlCapability.command_type(), list(any())) :: binary
  def to_bin(:get_rooftop_state, []) do
    cmd_id = RooftopControlCapability.command_id(:get_rooftop_state)
    <<cmd_id>>
  end
end
