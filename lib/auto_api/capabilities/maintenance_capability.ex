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
defmodule AutoApi.MaintenanceCapability do
  @moduledoc """
  Basic settings for Maintenance Capability

      iex> alias AutoApi.MaintenanceCapability, as: M
      iex> M.identifier
      <<0x00, 0x34>>
      iex> M.capability_size
      1
      iex> M.name
      :maintenance
      iex> M.description
      "Maintenance"
      iex> M.command_name(0x00)
      :get_maintenance_state
      iex> M.command_name(0x01)
      :maintenance_state
      iex> M.to_map(<<0x1, 0x0>>)
      [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: ""}]
      iex> M.to_map(<<0x1, 0x1>>)
      [%{atom: :available, bin: <<0x1>>, name: "Available", title: ""}]
  """

  @spec_file nil
  @properties []

  @identifier <<0x00, 0x34>>
  @name :maintenance
  @desc "Maintenance"
  @commands %{
    0x00 => :get_maintenance_state,
    0x01 => :maintenance_state,
  }
  @type command_type :: :get_maintenance_state | :maintenance_state
  @capability_size 1
  @sub_capabilities [
    %{
      options: %{
        :unavailable => %{name: "Unavailable", bin: <<0x00>>},
        :available => %{name: "Available", bin: <<0x01>>},
      }
    }
  ]

  @command_module AutoApi.MaintenanceCommand
  @state_module AutoApi.MaintenanceState

  use AutoApi.Capability
end
