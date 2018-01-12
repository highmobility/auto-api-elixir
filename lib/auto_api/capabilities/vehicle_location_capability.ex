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
defmodule AutoApi.VehicleLocationCapability do
  @moduledoc """
  Basic settings for VehicleLocation Capability

      iex> alias AutoApi.VehicleLocationCapability, as: VL
      iex> VL.identifier
      <<0x00, 0x30>>
      iex> VL.capability_size
      1
      iex> VL.name
      :vehicle_location
      iex> VL.description
      "Vehicle Location"
      iex> VL.command_name(0x00)
      :get_vehicle_location
      iex> VL.command_name(0x01)
      :vehicle_location
      iex> VL.to_map(<<0x1, 0x0>>)
      [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: ""}]
      iex> VL.to_map(<<0x1, 0x1>>)
      [%{atom: :available, bin: <<0x1>>, name: "Available", title: ""}]
  """

  @identifier <<0x00, 0x30>>
  @name :vehicle_location
  @desc "Vehicle Location"
  @commands %{
    0x00 => :get_vehicle_location,
    0x01 => :vehicle_location,
  }
  @type command_type :: :get_vehicle_location | :vehicle_location
  @capability_size 1
  @sub_capabilities [
    %{
      options: %{
        :unavailable => %{name: "Unavailable", bin: <<0x00>>},
        :available => %{name: "Available", bin: <<0x01>>},
      }
    }
  ]


  @command_module AutoApi.VehicleLocationCommand
  @state_module AutoApi.VehicleLocationState

  use AutoApi.Capability
end
