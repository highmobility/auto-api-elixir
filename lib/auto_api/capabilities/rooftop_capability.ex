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
defmodule AutoApi.RooftopCapability do
  @moduledoc """
  Basic settings for Rooftop Capability

      iex> alias AutoApi.RooftopCapability, as: RT
      iex> RT.identifier
      <<0x00, 0x25>>
      iex> RT.capability_size
      2
      iex> RT.name
      :rooftop
      iex> RT.description
      "Rooftop"
      iex> RT.command_name(0x00)
      :get_rooftop_state
      iex> RT.command_name(0x01)
      :rooftop_state
      iex> RT.command_name(0x02)
      :control_rooftop
      iex> RT.to_map(<<0x2, 0x0, 0x0>>)
      [%{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: "Dimming"}, %{bin: <<0x00>>, name: "Unavailable", atom: :unavailable, title: "Open/Close"}]
      iex> RT.to_map(<<0x2, 0x1, 0x03>>)
      [%{atom: :available, bin: <<0x1>>, name: "Available", title: "Dimming"}, %{atom: :no_name, bin: <<0x3>>, name: "0% or 100% Available", title: "Open/Close"}]
  """

  @identifier <<0x00, 0x25>>
  @name :rooftop
  @desc "Rooftop"
  @commands %{
    0x00 => :get_rooftop_state,
    0x01 => :rooftop_state,
    0x02 => :control_rooftop
  }
  @type command_type :: :get_rooftop_state | :rooftop_state | :control_rooftop
  @capability_size 2
  @sub_capabilities [
    %{
      title: "Dimming",
      position: 1,
      options:
      %{
        :unavailable => %{name: "Unavailable", bin: <<0x00>>},
        :available => %{name: "Available", bin: <<0x01>>},
        :state => %{name: "Get State", bin: <<0x02>>},
        :no_name => %{name: "0% or 100% Available", bin: <<0x03>>},
      }
    },
    %{
      title: "Open/Close",
      position: 2,
      options: %{
        :unavailable => %{name: "Unavailable", bin: <<0x00>>},
        :available => %{name: "Available", bin: <<0x01>>},
        :state => %{name: "Get State", bin: <<0x02>>},
        :no_name => %{name: "0% or 100% Available", bin: <<0x03>>},
      }
    }
  ]

  @command_module AutoApi.RooftopCommand
  @state_module AutoApi.RooftopState

  use AutoApi.Capability
end
