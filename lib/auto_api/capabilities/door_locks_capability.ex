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
defmodule AutoApi.DoorLocksCapability do
  @moduledoc """
  Basic settings for Door Locks Capability

      iex> alias AutoApi.DoorLocksCapability, as: D
      iex> D.identifier
      <<0x00, 0x20>>
      iex> D.capability_size
      1
      iex> D.name
      :door_locks
      iex> D.description
      "Door Locks"
      iex> D.command_name(0x00)
      :get_lock_state
      iex> D.command_name(0x01)
      :lock_state
      iex> D.command_name(0x12)
      :lock_unlock_doors
      iex> length(D.properties)
      3
      iex> List.last(D.properties)
      {0x04, :positions}
  """

  @spec_file "specs/door_locks.json"
  @type command_type :: :get_lock_state | :lock_state | :lock_unlock_doors
  @capability_size 1
  @sub_capabilities []

  @command_module AutoApi.DoorLocksCommand
  @state_module AutoApi.DoorLocksState

  use AutoApi.Capability
end
