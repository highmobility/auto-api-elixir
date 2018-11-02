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
defmodule AutoApi.VehicleLocationCommand do
  @moduledoc """
  Handles  commands and apply binary commands on `%AutoApi.VehicleLocationState{}`
  """
  @behaviour AutoApi.Command

  alias AutoApi.VehicleLocationCapability

  @doc """
  Returns binary command
      iex> AutoApi.DoorLocksCommand.to_bin(:get_lock_state, [])
      <<0x00>>
  """
  @spec to_bin(VehicleLocationCapability.command_type(), list(any)) :: binary
  def to_bin(cmd, _args) when cmd in [:vehicle_location, :get_vehicle_location] do
    cmd_id = VehicleLocationCapability.command_id(cmd)
    <<cmd_id>>
  end
end
