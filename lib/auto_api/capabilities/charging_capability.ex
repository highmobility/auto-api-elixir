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
defmodule AutoApi.ChargeCapability do
  @moduledoc """
  Basic settings for Maintenance Capability

      iex> alias AutoApi.ChargeCapability, as: E
      iex> E.identifier
      <<0x00, 0x23>>
      iex> E.capability_size
      1
      iex> E.name
      :charging
      iex> E.description
      "Charging"
      iex> E.command_name(0x00)
      :get_charge_state
      iex> E.command_name(0x01)
      :charge_state
      iex> E.command_name(0x02)
      :start_stop_charging
      iex> E.command_name(0x03)
      :set_charge_limit
      iex> E.to_map(<<0x1, 0x0>>)
      [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: ""}]
      iex> E.to_map(<<0x1, 0x1>>)
      [%{atom: :available, bin: <<0x1>>, name: "Available", title: ""}]
      iex> E.to_map(<<0x1, 0x2>>)
      [%{atom: :state, bin: <<0x2>>, name: "Get State", title: ""}]

  """

  @spec_file nil
  @properties []

  @identifier <<0x00, 0x23>>
  @name :charging
  @desc "Charging"
  @commands %{
    0x00 => :get_charge_state,
    0x01 => :charge_state,
    0x02 => :start_stop_charging,
    0x03 => :set_charge_limit,
  }
  @type command_type :: :get_charge_state | :charge_state | :start_stop_charging | :set_charge_limit
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

  @command_module AutoApi.ChargeCommand
  @state_module AutoApi.ChargeState

  use AutoApi.Capability
end
