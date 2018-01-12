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
defmodule AutoApi.TrunkAccessCapability do
  @moduledoc """
  Basic settings for Diagnostics Capability

      iex> alias AutoApi.TrunkAccessCapability, as: TA
      iex> TA.identifier
      <<0x00, 0x21>>
      iex> TA.capability_size
      2
      iex> TA.name
      :trunk_access
      iex> TA.description
      "Trunk Access"
      iex> TA.command_name(0x00)
      :get_trunk_state
      iex> TA.command_name(0x01)
      :trunk_state
      iex> TA.command_name(0x02)
      :open_close_trunk
      iex> TA.to_map(<<0x2, 0x0, 0x0>>)
      [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: "Lock"}, %{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: "Position"}]
      iex> TA.to_map(<<0x2, 0x01, 0x01>>)
      [%{atom: :available, bin: <<0x1>>, name: "Available", title: "Lock"}, %{bin: <<0x01>>, name: "Available", atom: :available, title: "Position"}]
      iex> TA.to_map(<<0x2, 0x02, 0x02>>)
      [%{atom: :state, bin: <<0x2>>, name: "Get State", title: "Lock"}, %{bin: <<0x02>>, name: "Get State", atom: :state, title: "Position"}]
      iex> TA.to_map(<<0x2, 0x03, 0x03>>)
      [%{atom: :state_unlock, bin: <<0x3>>, name: "Get State, Unlock Available", title: "Lock"}, %{bin: <<0x03>>, name: "Get State, Open Available", atom: :state_open, title: "Position"}]
  """

  @spec_file nil
  @properties []

  @identifier <<0x00, 0x21>>
  @name :trunk_access
  @desc "Trunk Access"
  @commands %{
    0x00 => :get_trunk_state,
    0x01 => :trunk_state,
    0x02 => :open_close_trunk,
  }
  @type command_type :: :get_trunk_state | :trunk_state | :open_close_trunk
  @capability_size 2
  @sub_capabilities [
    %{
      title: "Lock",
      options: %{
        :unavailable => %{name: "Unavailable", bin: <<0x00>>},
        :available => %{name: "Available", bin: <<0x01>>},
        :state => %{name: "Get State", bin: <<0x02>>},
        :state_unlock => %{name: "Get State, Unlock Available", bin: <<0x03>>},
      }
    },
    %{
      title: "Position",
      options: %{
        :unavailable => %{name: "Unavailable", bin: <<0x00>>},
        :available => %{name: "Available", bin: <<0x01>>},
        :state => %{name: "Get State", bin: <<0x02>>},
        :state_open => %{name: "Get State, Open Available", bin: <<0x03>>},
      }
    }
  ]

  @command_module AutoApi.TrunkAccessCommand
  @state_module AutoApi.TrunkAccessState

  use AutoApi.Capability
end
