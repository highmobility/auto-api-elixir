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
defmodule AutoApi.EngineCapability do
  @moduledoc """
  Basic settings for Maintenance Capability

      iex> alias AutoApi.EngineCapability, as: E
      iex> E.identifier
      <<0x00, 0x35>>
      iex> E.capability_size
      1
      iex> E.name
      :engine
      iex> E.description
      "Engine"
      iex> E.command_name(0x00)
      :get_ignition_state
      iex> E.command_name(0x01)
      :ignition_state
      iex> E.command_name(0x02)
      :turn_engine_on_off
      iex> E.to_map(<<0x1, 0x0>>)
      [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: ""}]
      iex> E.to_map(<<0x1, 0x1>>)
      [%{atom: :available, bin: <<0x1>>, name: "Available", title: ""}]
      iex> E.to_map(<<0x1, 0x2>>)
      [%{atom: :state, bin: <<0x2>>, name: "Get State", title: ""}]

  """

  @identifier <<0x00, 0x35>>
  @name :engine
  @desc "Engine"
  @commands %{
    0x00 => :get_ignition_state,
    0x01 => :ignition_state,
    0x02 => :turn_engine_on_off,
  }
  @type command_type :: :get_ignition_state | :ignition_state | :turn_engine_on_off
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


  @command_module AutoApi.EngineCommand
  @state_module AutoApi.EngineState

  use AutoApi.Capability
end
