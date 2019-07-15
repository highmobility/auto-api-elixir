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
defmodule AutoApi.CruiseControlCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.CruiseControlState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.CruiseControlState
  alias AutoApi.CruiseControlCapability

  @doc """
  Parses the binary command and makes changes or returns the state
  """
  @spec execute(CruiseControlState.t(), binary) ::
          {:state | :state_changed, CruiseControlState.t()}
  def execute(%CruiseControlState{} = state, <<0x00>>) do
    {:state, state}
  end

  def execute(%CruiseControlState{} = state, <<0x01, ds::binary>>) do
    new_state = CruiseControlState.from_bin(ds)

    if new_state == state do
      {:state, state}
    else
      {:state_changed, new_state}
    end
  end

  @doc """
  Converts Command state to capability's state in binary
  """
  @spec state(CruiseControlState.t()) :: binary
  def state(%CruiseControlState{} = state) do
    <<0x01, CruiseControlState.to_bin(state)::binary>>
  end

  @doc """
  Returns binary command
  """
  @spec to_bin(CruiseControlCapability.command_type(), list(any)) :: binary
  def to_bin(:get_cruise_control_state = msg, _args) do
    cmd_id = CruiseControlCapability.command_id(msg)
    <<cmd_id>>
  end

  def to_bin(:activate_deactivate_cruise_control = msg, []) do
    cmd_id = CruiseControlCapability.command_id(msg)
    <<cmd_id>>
  end
end
