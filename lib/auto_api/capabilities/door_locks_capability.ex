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
  Basic settings for DoorLocks Capability

      iex> alias AutoApi.DoorLocksCapability, as: DR
      iex> DR.identifier
      <<0x00, 0x20>>
      iex> DR.capability_size
      1
      iex> DR.name
      :door_locks
      iex> DR.description
      "Door Locks"
      iex> DR.command_name(0x00)
      :get_lock_state
      iex> DR.command_name(0x01)
      :lock_state
      iex> DR.command_name(0x02)
      :lock_unlock_doors
      iex> DR.to_map(<<0x1, 0x0>>)
      [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: ""}]
      iex> DR.to_map(<<0x1, 0x1>>)
      [%{atom: :available, bin: <<0x1>>, name: "Available", title: ""}]
      iex> DR.to_map(<<0x1, 0x2>>)
      [%{atom: :state, bin: <<0x2>>, name: "Get State", title: ""}]
  """

  @identifier <<0x00, 0x20>>
  @name :door_locks
  @desc "Door Locks"
  @commands %{
    0x00 => :get_lock_state,
    0x01 => :lock_state,
    0x02 => :lock_unlock_doors
  }
  @type command_type :: :get_lock_stae | :lock_state | :lock_unlock_doors
  @capability_size 1
  @sub_capabilities [
    %{
      options: %{
        :unavailable => %{name: "Unavailable", bin: <<0x00>>},
        :available => %{name: "Available", bin: <<0x01>>},
        :state => %{name: "Get State", bin: <<0x02>>},
      }
    }
  ]

  @command_module AutoApi.DoorLocksCommand
  @state_module AutoApi.DoorLocksState

  use AutoApi.Capability
end
